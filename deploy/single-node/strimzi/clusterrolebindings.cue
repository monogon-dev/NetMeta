package k8s

k8s: clusterrolebindings: {
	"strimzi-cluster-operator": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: {
			name: "strimzi-cluster-operator"
			labels: app: "strimzi"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "strimzi-cluster-operator"
			namespace: netmeta.config.namespace
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "strimzi-cluster-operator-global"
			apiGroup: "rbac.authorization.k8s.io"
		}
	}
	"strimzi-cluster-operator-kafka-broker-delegation": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: {
			name: "strimzi-cluster-operator-kafka-broker-delegation"
			labels: app: "strimzi"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "strimzi-cluster-operator"
			namespace: netmeta.config.namespace
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "strimzi-kafka-broker"
			apiGroup: "rbac.authorization.k8s.io"
		}
	}
	"strimzi-cluster-operator-kafka-client-delegation": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRoleBinding"
		metadata: {
			name: "strimzi-cluster-operator-kafka-client-delegation"
			labels: app: "strimzi"
		}
		subjects: [{
			kind:      "ServiceAccount"
			name:      "strimzi-cluster-operator"
			namespace: netmeta.config.namespace
		}]
		roleRef: {
			kind:     "ClusterRole"
			name:     "strimzi-kafka-client"
			apiGroup: "rbac.authorization.k8s.io"
		}
	}
}
