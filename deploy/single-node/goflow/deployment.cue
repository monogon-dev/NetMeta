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
							"-kafka.brokers",
							"netmeta-kafka-bootstrap:9092",
							"-proto.fixedlen=true",
							"-loglevel=debug",
							"-metrics.addr=[::1]:18080",
						]
						ports: [
							{name: "netflow-legacy", containerPort: 2056, protocol: "UDP"},
							{name: "netflow", containerPort:        2055, protocol: "UDP"},
							{name: "sflow", containerPort:          6343, protocol: "UDP"},
							{name: "metrics", containerPort:        8080, protocol: "TCP"},
						]
					},
				]
			}
		}
	}
}

k8s: services: goflow: {
	metadata: labels: app: "goflow"
	spec: {
		ports: [
			{name: "netflow-legacy", targetPort: name, port: 2056, protocol: "UDP"},
			{name: "netflow", targetPort:        name, port: 2055, protocol: "UDP"},
			{name: "sflow", targetPort:          name, port: 6343, protocol: "UDP"},
		]
		selector: app: "goflow"
	}
}

k8s: services: "goflow-metrics": {
	metadata: labels: app: "goflow"
	spec: {
		ports: [
			{name: "metrics", targetPort: name, port: 80, protocol: "TCP"},
		]
		selector: app: "goflow"
	}
}
