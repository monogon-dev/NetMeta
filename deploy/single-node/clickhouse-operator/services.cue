package k8s

k8s: services: "clickhouse-operator-metrics": {
	metadata: labels: app: "clickhouse-operator"
	spec: {
		ports: [{
			port: 8888
			name: "clickhouse-operator-metrics"
		}]
		selector: app: "clickhouse-operator"
	}
}
