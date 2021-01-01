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
						image: "docker.io/cloudflare/goflow:v3.4.2@sha256:dc78fadb655a60d2a46ff772d3db38d6d8af4817c2244b1671ac4fe7e0302b6f"
						command: [
							"./goflow",
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
