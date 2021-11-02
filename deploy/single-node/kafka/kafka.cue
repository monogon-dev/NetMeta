package k8s

k8s: kafkas: "netmeta": spec: {
	kafka: {
		version:  "3.0.0"
		replicas: 1
		listeners: [{
			name: "plain"
			port: 9092
			type: "internal"
			tls:  false
		}, {
			name: "tls"
			port: 9093
			type: "internal"
			tls:  true
		}]
		config: {
			"offsets.topic.replication.factor":         1
			"transaction.state.log.replication.factor": 1
			"transaction.state.log.min.isr":            1
			"log.message.format.version":               "3.0"
			"inter.broker.protocol.version":            "3.0"
		}
		storage: {
			type: "jbod"
			volumes: [{
				id:          0
				type:        "persistent-claim"
				size:        "100Gi"
				deleteClaim: false
			}]
		}
	}
	zookeeper: {
		replicas: 1
		storage: {
			type:        "persistent-claim"
			size:        "100Gi"
			deleteClaim: false
		}
	}
	entityOperator: {
		topicOperator: {}
		userOperator: {}
	}
}
