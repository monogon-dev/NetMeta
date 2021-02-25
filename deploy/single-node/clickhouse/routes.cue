package k8s

if netmeta.config.enableClickhouseIngress {
	k8s: ingressroutes: "clickhouse-ingress": spec: {
		entryPoints: ["clickhouse"]
		routes: [
			{
				match: "Host(`\(netmeta.config.publicHostname)`) && PathPrefix(`/`)"
				kind:  "Rule"
				services: [
					{
						name: "clickhouse-netmeta"
						port: 8123
					},
				]
			},
		]
		tls: passthrough: true
	}
}
