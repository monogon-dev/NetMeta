package k8s

k8s: rolebindings: {
	"strimzi-cluster-operator-entity-operator-delegation": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "RoleBinding"
		metadata: {
			name: "strimzi-cluster-operator-entity-operator-delegation"
			labels: app: "strimzi"
			namespace: netmeta.config.namespace
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "strimzi-cluster-operator"
			namespace: netmeta.config.namespace
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "strimzi-entity-operator"
			apiGroup: "rbac.authorization.k8s.io"
		}
	}
	"strimzi-cluster-operator": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "RoleBinding"
		metadata: {
			name: "strimzi-cluster-operator"
			labels: app: "strimzi"
			namespace: netmeta.config.namespace
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "strimzi-cluster-operator"
			namespace: netmeta.config.namespace
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "strimzi-cluster-operator-namespaced"
			apiGroup: "rbac.authorization.k8s.io"
		}
	}
}
