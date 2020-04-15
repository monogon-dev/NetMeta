package k8s

k8s: {
	rolebindings: {
		"strimzi-cluster-operator-entity-operator-delegation": {
			subjects: [{
				kind:      "ServiceAccount"
				name:      "strimzi-cluster-operator"
				namespace: NetMetaConfig.namespace
			}]
			roleRef: {
				kind:     "ClusterRole"
				name:     "strimzi-entity-operator"
				apiGroup: "rbac.authorization.k8s.io"
			}
		}
		"strimzi-cluster-operator-topic-operator-delegation": {
			subjects: [{
				kind:      "ServiceAccount"
				name:      "strimzi-cluster-operator"
				namespace: NetMetaConfig.namespace
			}]
			roleRef: {
				kind:     "ClusterRole"
				name:     "strimzi-topic-operator"
				apiGroup: "rbac.authorization.k8s.io"
			}
		}
		"strimzi-cluster-operator": {
			subjects: [{
				kind:      "ServiceAccount"
				name:      "strimzi-cluster-operator"
				namespace: NetMetaConfig.namespace
			}]
			roleRef: {
				kind:     "ClusterRole"
				name:     "strimzi-cluster-operator-namespaced"
				apiGroup: "rbac.authorization.k8s.io"
			}
		}
	}

	clusterrolebindings: {
		"strimzi-cluster-operator": {
			subjects: [{
				kind:      "ServiceAccount"
				name:      "strimzi-cluster-operator"
				namespace: NetMetaConfig.namespace
			}]
			roleRef: {
				kind:     "ClusterRole"
				name:     "strimzi-cluster-operator-global"
				apiGroup: "rbac.authorization.k8s.io"
			}
		}
		"strimzi-cluster-operator-kafka-broker-delegation": {
			subjects: [{
				kind:      "ServiceAccount"
				name:      "strimzi-cluster-operator"
				namespace: NetMetaConfig.namespace
			}]
			roleRef: {
				kind:     "ClusterRole"
				name:     "strimzi-kafka-broker"
				apiGroup: "rbac.authorization.k8s.io"
			}
		}
	}

	clusterroles: {
		"strimzi-entity-operator": rules: [{
			apiGroups: [
				"kafka.strimzi.io",
			]
			resources: [
				"kafkatopics",
				"kafkatopics/status",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"patch",
				"update",
				"delete",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"events",
			]
			verbs: [
				"create",
			]
		}, {
			apiGroups: [
				"kafka.strimzi.io",
			]
			resources: [
				"kafkausers",
				"kafkausers/status",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"patch",
				"update",
				"delete",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"secrets",
			]
			verbs: [
				"get",
				"list",
				"create",
				"patch",
				"update",
				"delete",
			]
		}]
		"strimzi-cluster-operator-global": rules: [{
			apiGroups: [
				"rbac.authorization.k8s.io",
			]
			resources: [
				"clusterrolebindings",
			]
			verbs: [
				"get",
				"create",
				"delete",
				"patch",
				"update",
				"watch",
			]
		}, {
			apiGroups: [
				"storage.k8s.io",
			]
			resources: [
				"storageclasses",
			]
			verbs:
			// Persistent Volumes can be resized only when it is supported in the storage class.
			// Therefore we need the ability to get the storage class details and we require this access right.
			[
				"get",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"nodes",
			]
			verbs:
			// The listing of nodes is needed to find the node addresses when the NodePort access is configured and set the proper
			// addresses in the status
			[
				"list",
			]
		}]
		"strimzi-cluster-operator-namespaced": rules: [{
			apiGroups: [
				"",
			]
			resources: [
				"serviceaccounts",
			]
			verbs: [
				"get",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"rbac.authorization.k8s.io",
			]
			resources: [
				"rolebindings",
			]
			verbs: [
				"get",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"configmaps",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"kafka.strimzi.io",
			]
			resources:
			// The cluster operator runs the KafkaAssemblyOperator, which needs to access Kafka resources
			[
				"kafkas",
				"kafkas/status",
				"kafkaconnects",
				"kafkaconnects/status",
				"kafkaconnects2is",
				"kafkaconnects2is/status",
				"kafkaconnectors",
				"kafkaconnectors/status",
				"kafkamirrormakers",
				"kafkamirrormakers/status",
				"kafkabridges",
				"kafkabridges/status",
				"kafkamirrormaker2s",
				"kafkamirrormaker2s/status",
			]
			// The cluster operator runs the KafkaConnectAssemblyOperator, which needs to access KafkaConnect resources
			// The cluster operator runs the KafkaConnectS2IAssemblyOperator, which needs to access KafkaConnectS2I resources
			// The cluster operator runs the KafkaConnectorAssemblyOperator, which needs to access KafkaConnector resources
			// The cluster operator runs the KafkaMirrorMakerAssemblyOperator, which needs to access KafkaMirrorMaker resources
			// The cluster operator runs the KafkaBridgeAssemblyOperator, which needs to access BridgeMaker resources
			// The cluster operator runs the KafkaMirrorMaker2AssemblyOperator, which needs to access KafkaMirrorMaker2 resources
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"pods",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"delete",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"services",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"endpoints",
			]
			verbs: [
				"get",
				"list",
				"watch",
			]
		}, {
			apiGroups: [
				"extensions",
			]
			resources: [
				"deployments",
				"deployments/scale",
				"replicasets",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"apps",
			]
			resources: [
				"deployments",
				"deployments/scale",
				"deployments/status",
				"statefulsets",
				"replicasets",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"events",
			]
			verbs: [
				"create",
			]
		}, {
			apiGroups:
			// OpenShift S2I requirements
			[
				"extensions",
			]
			resources: [
				"replicationcontrollers",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"apps.openshift.io",
			]
			resources: [
				"deploymentconfigs",
				"deploymentconfigs/scale",
				"deploymentconfigs/status",
				"deploymentconfigs/finalizers",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"build.openshift.io",
			]
			resources: [
				"buildconfigs",
				"builds",
			]
			verbs: [
				"create",
				"delete",
				"get",
				"list",
				"patch",
				"watch",
				"update",
			]
		}, {
			apiGroups: [
				"image.openshift.io",
			]
			resources: [
				"imagestreams",
				"imagestreams/status",
			]
			verbs: [
				"create",
				"delete",
				"get",
				"list",
				"watch",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"replicationcontrollers",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"secrets",
			]
			verbs: [
				"get",
				"list",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"extensions",
			]
			resources: [
				"networkpolicies",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"networking.k8s.io",
			]
			resources: [
				"networkpolicies",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"route.openshift.io",
			]
			resources: [
				"routes",
				"routes/custom-host",
			]
			verbs: [
				"get",
				"list",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"persistentvolumeclaims",
			]
			verbs: [
				"get",
				"list",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"policy",
			]
			resources: [
				"poddisruptionbudgets",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"extensions",
			]
			resources: [
				"ingresses",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}]
		"strimzi-cluster-operator-namespaced": rules: [{
			apiGroups: [
				"",
			]
			resources: [
				"serviceaccounts",
			]
			verbs: [
				"get",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"rbac.authorization.k8s.io",
			]
			resources: [
				"rolebindings",
			]
			verbs: [
				"get",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"configmaps",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"kafka.strimzi.io",
			]
			resources:
			// The cluster operator runs the KafkaAssemblyOperator, which needs to access Kafka resources
			[
				"kafkas",
				"kafkas/status",
				"kafkaconnects",
				"kafkaconnects/status",
				"kafkaconnects2is",
				"kafkaconnects2is/status",
				"kafkaconnectors",
				"kafkaconnectors/status",
				"kafkamirrormakers",
				"kafkamirrormakers/status",
				"kafkabridges",
				"kafkabridges/status",
				"kafkamirrormaker2s",
				"kafkamirrormaker2s/status",
			]
			// The cluster operator runs the KafkaConnectAssemblyOperator, which needs to access KafkaConnect resources
			// The cluster operator runs the KafkaConnectS2IAssemblyOperator, which needs to access KafkaConnectS2I resources
			// The cluster operator runs the KafkaConnectorAssemblyOperator, which needs to access KafkaConnector resources
			// The cluster operator runs the KafkaMirrorMakerAssemblyOperator, which needs to access KafkaMirrorMaker resources
			// The cluster operator runs the KafkaBridgeAssemblyOperator, which needs to access BridgeMaker resources
			// The cluster operator runs the KafkaMirrorMaker2AssemblyOperator, which needs to access KafkaMirrorMaker2 resources
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"pods",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"delete",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"services",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"endpoints",
			]
			verbs: [
				"get",
				"list",
				"watch",
			]
		}, {
			apiGroups: [
				"extensions",
			]
			resources: [
				"deployments",
				"deployments/scale",
				"replicasets",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"apps",
			]
			resources: [
				"deployments",
				"deployments/scale",
				"deployments/status",
				"statefulsets",
				"replicasets",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"events",
			]
			verbs: [
				"create",
			]
		}, {
			apiGroups:
			// OpenShift S2I requirements
			[
				"extensions",
			]
			resources: [
				"replicationcontrollers",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"apps.openshift.io",
			]
			resources: [
				"deploymentconfigs",
				"deploymentconfigs/scale",
				"deploymentconfigs/status",
				"deploymentconfigs/finalizers",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"build.openshift.io",
			]
			resources: [
				"buildconfigs",
				"builds",
			]
			verbs: [
				"create",
				"delete",
				"get",
				"list",
				"patch",
				"watch",
				"update",
			]
		}, {
			apiGroups: [
				"image.openshift.io",
			]
			resources: [
				"imagestreams",
				"imagestreams/status",
			]
			verbs: [
				"create",
				"delete",
				"get",
				"list",
				"watch",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"replicationcontrollers",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"secrets",
			]
			verbs: [
				"get",
				"list",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"extensions",
			]
			resources: [
				"networkpolicies",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"networking.k8s.io",
			]
			resources: [
				"networkpolicies",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"route.openshift.io",
			]
			resources: [
				"routes",
				"routes/custom-host",
			]
			verbs: [
				"get",
				"list",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"persistentvolumeclaims",
			]
			verbs: [
				"get",
				"list",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"policy",
			]
			resources: [
				"poddisruptionbudgets",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}, {
			apiGroups: [
				"extensions",
			]
			resources: [
				"ingresses",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"delete",
				"patch",
				"update",
			]
		}]
		"strimzi-topic-operator": rules: [{
			apiGroups: [
				"kafka.strimzi.io",
			]
			resources: [
				"kafkatopics",
			]
			verbs: [
				"get",
				"list",
				"watch",
				"create",
				"patch",
				"update",
				"delete",
			]
		}, {
			apiGroups: [
				"",
			]
			resources: [
				"events",
			]
			verbs: [
				"create",
			]
		}]
		"strimzi-kafka-broker": rules: [{
			apiGroups: [
				"",
			]
			resources: [
				"nodes",
			]
			verbs: [
				"get",
			]
		}]
	}

	serviceaccounts: "strimzi-cluster-operator": {
	}
}
