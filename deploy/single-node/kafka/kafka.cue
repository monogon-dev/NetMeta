package k8s

k8s: kafkas: "netmeta": spec: {
	kafka: {
		version:  "2.4.0"
		replicas: 1
		listeners: {
			plain: {}
			tls: {}
		}
		config: {
			"offsets.topic.replication.factor":         1
			"transaction.state.log.replication.factor": 1
			"transaction.state.log.min.isr":            1
			"log.message.format.version":               "2.4"
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
