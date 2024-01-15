# risinfo

risinfo serves a prefix -> origin mapping derived from routeviews.org RIB dumps as a ClickHouse dictionary.
This data is much more recent than Maxmind ASN data.

It's quite expensive to fetch and process a full internet routing table (~60s). In the future, we may introduce a layer of server-side caching with prebuilt lookup tables available for download.