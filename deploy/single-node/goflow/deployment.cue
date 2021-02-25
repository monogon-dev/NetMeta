package k8s

if netmeta.config.ingressType == "goflow" {
	k8s: deployments: goflow: {
		M=metadata: labels: app: "goflow"
		spec: {
			strategy: type: "Recreate"
			selector: matchLabels: app: M.labels.app
			template: {
				metadata: labels: app: M.labels.app

				// Trigger redeployment when digest changes.
				metadata: annotations: "meta/local-image-digest": netmeta.images.goflow.digest

				spec: {
					// k3s does not support IPv6 networking, so we run goflow in the host network namespace.
					hostNetwork: true
					dnsPolicy:   "ClusterFirstWithHostNet"
					containers: [
						{
							name:  "goflow"
							image: netmeta.images.goflow.image

							// Removed in 58175b24, explicitly zero it for backwards compatibility.
							command: []

							args: [
								"-kafka.brokers=netmeta-kafka-bootstrap:9092",
								"-proto.fixedlen=true",
								"-loglevel=debug",
								"-metrics.addr=127.0.0.1:18080",
								"-nf.port=\(netmeta.config.ports.netflow)",
								"-nfl.port=\(netmeta.config.ports.netflowLegacy)",
								"-sflow.port=\(netmeta.config.ports.sflow)",
							]

							// Workaround for mlock crashes until Go 1.16 is released.
							//   https://go-review.googlesource.com/c/go/+/246200/
							//   https://github.com/golang/go/issues/40184
							env: [{name: "GODEBUG", value: "mlock=0"}]

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
