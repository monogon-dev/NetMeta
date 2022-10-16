// risinfo serves a prefix -> origin mapping derived from routeviews.org RIB dumps as a ClickHouse dictionary.
// This data is much more recent than Maxmind ASN data.
//
// It's quite expensive to fetch and process a full internet routing table (~60s). In the future, we may introduce
// a layer of server-side caching with prebuilt lookup tables available for download.
package main

import (
	"bufio"
	"compress/bzip2"
	"context"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"path"
	"regexp"
	"sync"
	"time"

	"github.com/osrg/gobgp/pkg/packet/bgp"
	"github.com/osrg/gobgp/pkg/packet/mrt"

	"k8s.io/klog/v2"
)

var (
	addr        = flag.String("addr", ":8080", "Listening address [:8080]")
	cacheDir    = flag.String("cacheDir", "/tmp/risinfo-cache", "Caching directory")
	maxCacheAge = flag.Duration("maxCacheAge", 8*time.Hour, "Local RIB cache timeout")

	// Global cache write lock
	mu sync.RWMutex
)

const (
	// Be friendly to data sources and identify properly to any third party data sources.
	// This currently redirects to this source code file.
	userAgent = "NetMeta/0.1 (+https://netmeta-cache.leoluk.de/v1/about)"

	// Route all requests via our own caching proxy to avoid accidentally overloading the data source if NetMeta were to
	// experience a sudden spike in popularity.
	//
	// True origin is http://archive.routeviews.org/route-views4/bgpdata.
	ribDumpURI = "https://netmeta-cache.leoluk.de/v1/routeviews"

	// In order to resolve AS numbers to descriptions, we need data from every individual IRRs. Thankfully, someone else
	// already did the hard work of aggregating them, and we can just fetch that (origin is
	// https://bgp.potaroo.net/cidr/autnums.html, we cache it to avoid causing load).
	autnumURI = "https://netmeta-cache.leoluk.de/v1/autnums.html"
)

func init() {
	klog.InitFlags(nil)
}

// serveAutnums requests and parses autnums.html and writes its contents as tab-separated (asnum, asname, country)
// lines to an io.Writer.
func serveAutnums(ctx context.Context, w io.Writer) error {
	autnumRegexp, err := regexp.Compile(`<a .*>AS(\d+)\s*<\/a>\s*(.*), ([A-Z]+)`) // Hi Zalgo
	if err != nil {
		panic(err)
	}

	req, err := http.NewRequestWithContext(ctx, "GET", autnumURI, nil)
	if err != nil {
		panic(err)
	}
	req.Header.Set("user-agent", userAgent)

	resp, err := new(http.Client).Do(req)
	if err != nil {
		return fmt.Errorf("failed to request autnums.html: %w", err)
	}
	defer resp.Body.Close()

	s := bufio.NewScanner(resp.Body)

	for s.Scan() {
		t := s.Text()
		m := autnumRegexp.FindStringSubmatch(t)

		if m != nil {
			if _, err := fmt.Fprintf(w, "%s\t%s\t%s\n", m[1], m[2], m[3]); err != nil {
				return fmt.Errorf("failed to write response: %w", err)
			}
		}
	}

	if err := s.Err(); err != nil {
		return fmt.Errorf("failed to scan input: %w", err)
	}

	return nil
}

func fetchLatestRIB(ctx context.Context) (io.ReadCloser, error) {
	utc := time.Now().UTC()
	c := http.Client{}

	// Dumps are made every two hours. Backtrack at most four hours when looking for latest dump.
	for i := 0; i < 5; i++ {
		t := utc.Add(time.Duration(-i) * time.Hour)
		d := t.Format("2006.01")
		f := t.Format("rib.20060102.1500") + ".bz2"
		u := fmt.Sprintf("%s/%s/RIBS/%s", ribDumpURI, d, f)

		klog.Infof("trying %s", u)

		req, err := http.NewRequestWithContext(ctx, "GET", u, nil)
		if err != nil {
			panic(err)
		}
		req.Header.Set("user-agent", userAgent)

		resp, err := c.Do(req)
		if err != nil {
			return nil, fmt.Errorf("error when requesting %s: %w", u, err)
		}

		if resp.StatusCode == 200 {
			klog.Info("downloading latest RIB from NetMeta's routeviews.org cache: ", u)
			return resp.Body, nil
		}
	}

	return nil, nil
}

func parseMRT(r io.Reader) (map[string]uint32, error) {
	result := make(map[string]uint32)

	s := bufio.NewScanner(r)
	s.Split(mrt.SplitMrt)
	count := 0

	for s.Scan() {
		d := s.Bytes()
		count++

		if count%10000 == 0 {
			klog.V(1).Infof("progress: %d", count)
		}

		hdr := &mrt.MRTHeader{}
		err := hdr.DecodeFromBytes(d[:mrt.MRT_COMMON_HEADER_LEN])
		if err != nil {
			return nil, fmt.Errorf("failed to decode header: %w", err)
		}

		msg, err := mrt.ParseMRTBody(hdr, d[mrt.MRT_COMMON_HEADER_LEN:])
		if err != nil {
			return nil, fmt.Errorf("failed to parse body: %w", err)
		}

		if msg.Header.Type != mrt.TABLE_DUMPv2 {
			return nil, fmt.Errorf("invalid MRT file type, expected TABLE_DUMPv2, got %v", msg.Header.Type)
		}

		body, ok := msg.Body.(*mrt.Rib)
		if !ok {
			continue
		}

		st := mrt.MRTSubTypeTableDumpv2(msg.Header.SubType)
		var prefix string
		switch st {
		case mrt.RIB_IPV4_UNICAST:
			// IPv6 "subnets" for truncated IPv6-mapped IPv4
			p := body.Prefix.(*bgp.IPAddrPrefix)
			if p.Length == 0 {
				klog.V(1).Infof("ignoring IPv4 default route: %+v", body)
				continue
			}
			prefix = fmt.Sprintf("::%s/%d", p.Prefix.String(), p.Length+96)
		case mrt.RIB_IPV6_UNICAST:
			p := body.Prefix.(*bgp.IPv6AddrPrefix)
			if p.Length == 0 {
				klog.V(1).Infof("ignoring IPv6 default route: %+v", body)
				continue
			}
			prefix = body.Prefix.String()
		default:
			continue
		}

		if len(body.Entries) == 0 {
			continue
		}

		// We only want to know the origin, just read the first route entry.
		entry := body.Entries[0]

		for _, attr := range entry.PathAttributes {
			switch attr := attr.(type) {
			case *bgp.PathAttributeAsPath:
				if v, ok := attr.Value[0].(*bgp.As4PathParam); ok {
					result[prefix] = v.AS[len(v.AS)-1]
				}
			}
		}
	}

	if err := s.Err(); err != nil {
		return nil, fmt.Errorf("failed to scan input: %w", err)
	}

	klog.Infof("parsed %d routes", count)
	return result, nil
}

func handleRIB(w http.ResponseWriter, r *http.Request) {
	klog.Infof("%v %s %s", r.RemoteAddr, r.Method, r.URL)

	// Check if we can serve the RIB from local cache.
	mu.RLock()
	cacheFile := path.Join(*cacheDir, "rib-latest.tsv")
	fi, err := os.Stat(cacheFile)
	if err != nil {
		if os.IsNotExist(err) {
			klog.Info("empty local cache")
		} else {
			klog.Fatalf("error accessing cache file %s: %v", cacheFile, err)
		}
	} else {
		expiration := time.Now().Add(-*maxCacheAge)
		klog.V(1).Infof("oldest cache accepted: %s, ours: %s", expiration, fi.ModTime())
		if fi.ModTime().Before(expiration) {
			klog.Info("cache has expired")
		} else {
			klog.Info("cache is valid, serving request from cache")
			cf, err := os.Open(cacheFile)
			if err != nil {
				klog.Fatalf("error accessing cache file %s: %v", cacheFile, err)
			}

			if n, err := io.Copy(w, cf); err != nil {
				klog.Errorf("failed to write cached response: %v", err)
			} else {
				klog.Infof("%v sent %d bytes (cache hit)", r.RemoteAddr, n)
			}

			mu.RUnlock()
			return
		}
	}
	mu.RUnlock()

	// Cache is empty or stale - populate it while simultaneously writing the response.
	// We acquire the lock right away to prevent duplicate requests.
	mu.Lock()
	defer mu.Unlock()

	cf, err := os.CreateTemp(*cacheDir, "rib.*.tsv")
	if err != nil {
		klog.Fatalf("failed to open cache file %s: %v", cacheFile, err)
	}

	defer os.Remove(cf.Name())

	// Request latest RIB
	resp, err := fetchLatestRIB(r.Context())
	if err != nil {
		klog.Errorf("failed to fetch RIB: %v", err)
		w.WriteHeader(500)
		return
	}
	defer resp.Close()

	res, err := parseMRT(bzip2.NewReader(resp))
	if err != nil {
		klog.Errorf("failed to parse RIB: %v", err)
		w.WriteHeader(500)
		return
	}

	cw := io.MultiWriter(w, cf)

	var written int
	for p, asn := range res {
		n, err := fmt.Fprintf(cw, "%s\t%d\n", p, asn)
		written += n
		if err != nil {
			klog.Errorf("failed to write response or cache: %v", err)
			return
		}
	}

	// Response written successfully - commit cache.
	if err := os.Rename(cf.Name(), cacheFile); err != nil {
		klog.Fatalf("failed to rename cachecommit cache: %v", err)
	}

	klog.Infof("%v sent %d bytes (cache miss)", r.RemoteAddr, written)
}

func handleAutnums(w http.ResponseWriter, r *http.Request) {
	klog.Infof("%v %s %s", r.RemoteAddr, r.Method, r.URL)

	// This is a cheap request - we do not cache it locally.

	if err := serveAutnums(r.Context(), w); err != nil {
		klog.Errorf("failed to parse autnums.html: %v", err)
		w.WriteHeader(500)
		return
	}
}

func main() {
	flag.Parse()
	if err := os.MkdirAll(*cacheDir, 0750); err != nil {
		klog.Fatal(err)
	}

	http.HandleFunc("/rib.tsv", handleRIB)
	http.HandleFunc("/autnums.tsv", handleAutnums)

	klog.Fatal(http.ListenAndServe(*addr, nil))
}
