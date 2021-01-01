// risinfo serves a prefix -> origin mapping derived from routeviews.org RIB dumps as a ClickHouse dictionary.
// This data is much more recent than Maxmind ASN data.
//
// It's quite expensive to fetch and process a full internet routing table. In the future, we may introduce a layer of
// server-side caching with prebuilt lookup tables available for download.
package main

import (
	"bufio"
	"compress/bzip2"
	"context"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"time"

	"github.com/osrg/gobgp/pkg/packet/bgp"
	"github.com/osrg/gobgp/pkg/packet/mrt"
)

var (
	addr = flag.String("addr", ":8080", "Listening address [:8080]")
)

const (
	// Be friendly to data sources and identify properly to any third party data sources.
	// This currently redirects to this source code file.
	userAgent = "NetMeta/0.1 (+https://netmeta-cache.leoluk.de/v1/about)"

	// Route all requests via our own caching proxy to avoid accidentally overloading the data source if NetMeta were to
	// experience a sudden spike in popularity.
	//
	// True origin is http://archive.routeviews.org/route-views4/bgpdata.
	ribDumpPath = "https://netmeta-cache.leoluk.de/v1/routeviews"
)

func fetchLatestRIB(ctx context.Context) (io.ReadCloser, error) {
	utc := time.Now().UTC()
	c := http.Client{}

	// Dumps are made every two hours. Backtrack at most four hours when looking for latest dump.
	for i := 0; i < 5; i++ {
		t := utc.Add(time.Duration(-i) * time.Hour)
		d := t.Format("2006.01")
		f := t.Format("rib.20060102.1500") + ".bz2"
		u := fmt.Sprintf("%s/%s/RIBS/%s", ribDumpPath, d, f)

		log.Printf("Trying %s", u)

		req, err := http.NewRequestWithContext(ctx, "GET", u, nil)
		if err != nil {
			panic(err)
		}

		resp, err := c.Do(req)
		if err != nil {
			return nil, fmt.Errorf("error when requesting %s: %w", u, err)
		}

		if resp.StatusCode == 200 {
			log.Print("Downloading latest RIB from NetMeta's routeviews.org cache: ", u)
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
			prefix = fmt.Sprintf("::%s/%d", p.Prefix.String(), p.Length+96)
		case mrt.RIB_IPV6_UNICAST:
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

	log.Printf("Parsed %d routes", count)
	return result, nil
}

func handle(w http.ResponseWriter, r *http.Request) {
	resp, err := fetchLatestRIB(r.Context())
	if err != nil {
		log.Printf("failed to fetch RIB: %v", err)
		w.WriteHeader(500)
		return
	}
	defer resp.Close()

	res, err := parseMRT(bzip2.NewReader(resp))
	if err != nil {
		log.Printf("failed to parse RIB: %v", err)
		w.WriteHeader(500)
		return
	}

	for p, asn := range res {
		_, err = fmt.Fprintf(w, "%s\t%d\n", p, asn)
		if err != nil {
			log.Printf("failed to write response: %v", err)
			return
		}
	}
}

func main() {
	flag.Parse()

	http.HandleFunc("/rib.tsv", handle)

	log.Fatal(http.ListenAndServe(*addr, nil))
}
