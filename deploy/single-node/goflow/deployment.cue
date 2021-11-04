package k8s

if netmeta.config.deployGoflow {
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
							image: netmeta.images.goflow

							// Removed in 58175b24, explicitly zero it for backwards compatibility.
							command: []

							args: [
								"-transport=kafka",
								"-transport.kafka.brokers=netmeta-kafka-bootstrap:9092",
								"-format.protobuf.fixedlen=true",
								"-metrics.addr=127.0.0.1:18080",
								"-listen=sflow://:\(netmeta.config.ports.sflow),netflow://:\(netmeta.config.ports.netflow),nfl://:\(netmeta.config.ports.netflowLegacy)",
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
}
