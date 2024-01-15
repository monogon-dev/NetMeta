package kafka

#Config: {
	goflowTopicRetention:        int
	enableExternalKafkaListener: bool
	advertisedKafkaHost:         string
	fastNetMon?: {
		topicRetention: int
		...
	}
}

KafkaTopic: "flow-messages": {
	metadata: labels: "strimzi.io/cluster": "netmeta"
	spec: {
		partitions: 1
		replicas:   1
		config: "retention.bytes": "\(#Config.goflowTopicRetention)"
	}
}

if #Config.fastNetMon.topicRetention != _|_ {
	KafkaTopic: "fastnetmon": {
		metadata: labels: "strimzi.io/cluster": "netmeta"
		spec: {
			partitions: 1
			replicas:   1
			config: "retention.bytes": "\(#Config.fastNetMon.topicRetention)"
		}
	}
}

Kafka: "netmeta": spec: {
	kafka: {
		version:  "3.2.3"
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
			authentication: type: "tls"
		},
			if #Config.enableExternalKafkaListener {
				{
					name: "external"
					port: 9094
					type: "nodeport"
					tls:  false
					configuration: bootstrap: nodePort: 32100
					configuration: brokers: [{broker: 0, advertisedHost: #Config.advertisedKafkaHost}]
				}
			},
		]
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
