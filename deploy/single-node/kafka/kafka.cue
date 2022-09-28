package k8s

k8s: kafkas: "netmeta": spec: {
	kafka: {
		version:  "2.4.0"
		replicas: 1
		listeners: {
			plain: {}
			tls: {}
			if netmeta.config.enableExternalKafkaListener {
				external: {
					type: "nodeport"
					tls:  false
					overrides: brokers: [{broker: 0, advertisedHost: netmeta.config.advertisedKafkaHost}]
				}
			}
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
		jvmOptions: javaSystemProperties: [{name: "log4j2.formatMsgNoLookups", value: "true"}]
	}
	zookeeper: {
		replicas: 1
		storage: {
			type:        "persistent-claim"
			size:        "100Gi"
			deleteClaim: false
		}
		jvmOptions: javaSystemProperties: [{name: "log4j2.formatMsgNoLookups", value: "true"}]
	}
	entityOperator: {
		topicOperator: {
			jvmOptions: javaSystemProperties: [{name: "log4j2.formatMsgNoLookups", value: "true"}]
		}
		userOperator: {
			jvmOptions: javaSystemProperties: [{name: "log4j2.formatMsgNoLookups", value: "true"}]
		}
	}
}
