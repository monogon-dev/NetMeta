package k8s

k8s: serviceaccounts: "strimzi-cluster-operator": {
	apiVersion: "v1"
	kind:       "ServiceAccount"
	metadata: {
		name: "strimzi-cluster-operator"
		labels: app: "strimzi"
		namespace: netmeta.config.namespace
	}
}
