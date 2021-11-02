package k8s

k8s: clusterroles: {
	"strimzi-entity-operator": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: {
			name: "strimzi-entity-operator"
			labels: app: "strimzi"
		}
		rules: [{
			apiGroups: ["kafka.strimzi.io"]
			resources: ["kafkatopics", "kafkatopics/status", "kafkausers", "kafkausers/status"]
			verbs: ["get", "list", "watch", "create", "patch", "update", "delete"]
		}, {
			apiGroups: [""]
			resources: ["events"]
			verbs: ["create"]
		}, {
			apiGroups: [""]
			resources: ["secrets"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}]
	}
	"strimzi-cluster-operator-global": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: {
			name: "strimzi-cluster-operator-global"
			labels: app: "strimzi"
		}
		rules: [{
			apiGroups: ["rbac.authorization.k8s.io"]
			resources: ["clusterrolebindings"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["storage.k8s.io"]
			resources: ["storageclasses"]
			verbs: ["get"]
		}, {
			apiGroups: [""]
			resources: ["nodes"]
			verbs: ["list"]
		}]
	}
	"strimzi-cluster-operator-namespaced": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: {
			name: "strimzi-cluster-operator-namespaced"
			labels: app: "strimzi"
		}
		rules: [{
			apiGroups: ["rbac.authorization.k8s.io"]
			resources: ["rolebindings"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["rbac.authorization.k8s.io"]
			resources: ["roles"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: [""]
			resources: ["pods", "serviceaccounts", "configmaps", "services", "endpoints", "secrets", "persistentvolumeclaims"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["kafka.strimzi.io"]
			resources: ["kafkas", "kafkas/status", "kafkaconnects", "kafkaconnects/status", "kafkaconnectors", "kafkaconnectors/status", "kafkamirrormakers", "kafkamirrormakers/status", "kafkabridges", "kafkabridges/status", "kafkamirrormaker2s", "kafkamirrormaker2s/status", "kafkarebalances", "kafkarebalances/status"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["extensions"]
			resources: ["deployments", "deployments/scale", "replicasets", "replicationcontrollers", "networkpolicies", "ingresses"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["apps"]
			resources: ["deployments", "deployments/scale", "deployments/status", "statefulsets", "replicasets"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: [""]
			resources: ["events"]
			verbs: ["create"]
		}, {
			apiGroups: ["build.openshift.io"]
			resources: ["buildconfigs", "buildconfigs/instantiate", "builds"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["networking.k8s.io"]
			resources: ["networkpolicies", "ingresses"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["route.openshift.io"]
			resources: ["routes", "routes/custom-host"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}, {
			apiGroups: ["policy"]
			resources: ["poddisruptionbudgets"]
			verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
		}]
	}
	"strimzi-kafka-client": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: {
			name: "strimzi-kafka-client"
			labels: app: "strimzi"
		}
		rules: [{
			apiGroups: [""]
			resources: ["nodes"]
			verbs: ["get"]
		}]
	}
	"strimzi-kafka-broker": {
		apiVersion: "rbac.authorization.k8s.io/v1"
		kind:       "ClusterRole"
		metadata: {
			name: "strimzi-kafka-broker"
			labels: app: "strimzi"
		}
		rules: [{
			apiGroups: [""]
			resources: ["nodes"]
			verbs: ["get"]
		}]
	}
}
