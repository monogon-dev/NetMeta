package k8s

k8s: deployments: goflow: {
	M=metadata: labels: app: "goflow"
	spec: {
		strategy: type: "Recreate"
		selector: matchLabels: app: M.labels.app
		template: {
			metadata: labels: app: M.labels.app
			spec: {
				// k3s does not support IPv6 networking, so we run goflow in the host network namespace.
				hostNetwork: true
				dnsPolicy:   "ClusterFirstWithHostNet"
				containers: [
					{
						name:  "goflow"
						image: "cloudflare/goflow:v3.4.2"
						command: [
							"./goflow",
							"-kafka.brokers=netmeta-kafka-bootstrap:9092",
							"-proto.fixedlen=true",
							"-loglevel=debug",
							"-metrics.addr=[::1]:18080",
							"-nf.port=\(netmeta.config.ports.netflow)",
							"-nfl.port=\(netmeta.config.ports.netflowLegacy)",
							"-sflow.port=\(netmeta.config.ports.sflow)",
						]
						ports: [
							{name: "netflow-legacy", containerPort: netmeta.config.ports.netflowLegacy, protocol: "UDP"},
							{name: "netflow", containerPort:        netmeta.config.ports.netflow, protocol:       "UDP"},
							{name: "sflow", containerPort:          netmeta.config.ports.sflow, protocol:         "UDP"},
						]
					},
				]
			}
		}
	}
}
