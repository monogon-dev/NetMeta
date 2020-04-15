package k8s

k8s: kafkatopics: "flow-messages": {
	metadata: labels: "strimzi.io/cluster": "netmeta"
	spec: {
		partitions: 1
		replicas:   1
		config: "retention.bytes": NetMetaConfig.goflowTopicRetention
	}
}
