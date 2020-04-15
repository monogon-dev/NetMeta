package k8s

k8s: clusterrolebindings: "clickhouse-operator": {
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "cluster-admin"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "clickhouse-operator"
		namespace: NetMetaConfig.namespace
	}]
}
