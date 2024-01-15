package grafana

IngressRoute: "grafana-tls": spec: {
	entryPoints: ["websecure"]
	routes: [
		{
			match: "Host(`\(#Config.publicHostname)`) && PathPrefix(`/`)"
			kind:  "Rule"
			services: [
				{
					name: "grafana"
					port: 80
				},
			]
		},
	]
	tls: certResolver: "publicHostnameResolver"
}
