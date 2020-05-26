package k8s

k8s: deployments: goflow: {
	M=metadata: labels: app: "goflow"
	spec: {
		strategy: type: "Recreate"
		selector: matchLabels: app: M.labels.app
		template: {
			metadata: labels: app: M.labels.app
			spec: containers: [
				{
					name:  "goflow"
					image: "cloudflare/goflow:v3.4.2"
					command: [
						"./goflow",
						"-kafka.brokers",
						"netmeta-kafka-bootstrap:9092",
						"-proto.fixedlen=true",
						"-loglevel=debug",
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

// Use Traefik UDP load balancer as a workaround for the non-IPv6 workaround k8s uses for LoadBalancer objects
// and the lack of IPv6 support in NodePorts:
//
//  - https://github.com/rancher/k3s/issues/767
//  - https://github.com/leoluk/NetMeta/issues/4
//
// The individual entryPoints are defined in traefik/deployment.cue.
//
// This cannot be fixed without moving away from k3s.

k8s: ingressrouteudps: "goflow-netflow-legacy": spec: {
	entryPoints: ["udp-netflow-legacy"]
	routes: [
		{
			kind: "Rule"
			services: [
				{name: "goflow", port: 2056},
			]
		},
	]
}

k8s: ingressrouteudps: "goflow-netflow": spec: {
	entryPoints: ["udp-netflow"]
	routes: [
		{
			kind: "Rule"
			services: [
				{name: "goflow", port: 2055},
			]
		},
	]
}

k8s: ingressrouteudps: "goflow-sflow": spec: {
	entryPoints: ["udp-sflow"]
	routes: [
		{
			kind: "Rule"
			services: [
				{name: "goflow", port: 6343},
			]
		},
	]
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
