package k8s

k8s: ingressroutes: "grafana-tls": spec: {
	entryPoints: ["websecure"]
	routes: [
		{
			match: "Host(`\(netmeta.config.publicHostname)`) && PathPrefix(`/`)"
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
