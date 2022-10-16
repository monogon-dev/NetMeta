package goflow

#Config: {
	digest: string
	image:  string
	ports: {
		netflow:       int
		netflowLegacy: int
		sflow:         int
	}
}

Deployment: goflow: {
	M=metadata: labels: app: "goflow"
	spec: {
		strategy: type: "Recreate"
		selector: matchLabels: app: M.labels.app
		template: {
			metadata: labels: app: M.labels.app

			// Trigger redeployment when digest changes.
			metadata: annotations: "meta/local-image-digest": #Config.digest

			spec: {
				// k3s does not support IPv6 networking, so we run goflow in the host network namespace.
				hostNetwork: true
				dnsPolicy:   "ClusterFirstWithHostNet"
				containers: [
					{
						name:  "goflow"
						image: #Config.image

						// Removed in 58175b24, explicitly zero it for backwards compatibility.
						command: []

						args: [
							"-kafka.brokers=netmeta-kafka-bootstrap:9092",
							"-proto.fixedlen=true",
							"-loglevel=debug",
							"-metrics.addr=127.0.0.1:18080",
							"-nf.port=\(#Config.ports.netflow)",
							"-nfl.port=\(#Config.ports.netflowLegacy)",
							"-sflow.port=\(#Config.ports.sflow)",
						]

						env: [{name: "GODEBUG", value: "mlock=0"}]

						ports: [
							{name: "netflow-legacy", containerPort: #Config.ports.netflowLegacy, protocol: "UDP"},
							{name: "netflow", containerPort:        #Config.ports.netflow, protocol:       "UDP"},
							{name: "sflow", containerPort:          #Config.ports.sflow, protocol:         "UDP"},
						]
					},
				]
			}
		}
	}
}
