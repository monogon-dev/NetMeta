package k8s

k8s: deployments: "strimzi-cluster-operator": {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: {
		name: "strimzi-cluster-operator"
		labels: app: "strimzi"
		namespace: netmeta.config.namespace
	}
	spec: {
		replicas: 1
		selector: matchLabels: {
			name:              "strimzi-cluster-operator"
			"strimzi.io/kind": "cluster-operator"
		}
		template: {
			metadata: labels: {
				name:              "strimzi-cluster-operator"
				"strimzi.io/kind": "cluster-operator"
			}
			spec: {
				serviceAccountName: "strimzi-cluster-operator"
				volumes: [{
					name: "strimzi-tmp"
					emptyDir: {
						medium:    "Memory"
						sizeLimit: "1Mi"
					}
				}, {
					name: "co-config-volume"
					configMap: name: "strimzi-cluster-operator"
				}]
				containers: [{
					name:  "strimzi-cluster-operator"
					image: "quay.io/strimzi/operator:0.26.0"
					ports: [{
						containerPort: 8080
						name:          "http"
					}]
					args: ["/opt/strimzi/bin/cluster_operator_run.sh"]
					volumeMounts: [{
						name:      "strimzi-tmp"
						mountPath: "/tmp"
					}, {
						name:      "co-config-volume"
						mountPath: "/opt/strimzi/custom-config/"
					}]
					env: [{
						name: "STRIMZI_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						name:  "STRIMZI_FULL_RECONCILIATION_INTERVAL_MS"
						value: "120000"
					}, {
						name:  "STRIMZI_OPERATION_TIMEOUT_MS"
						value: "300000"
					}, {
						name:  "STRIMZI_DEFAULT_TLS_SIDECAR_ENTITY_OPERATOR_IMAGE"
						value: "quay.io/strimzi/kafka:0.26.0-kafka-3.0.0"
					}, {
						name:  "STRIMZI_DEFAULT_KAFKA_EXPORTER_IMAGE"
						value: "quay.io/strimzi/kafka:0.26.0-kafka-3.0.0"
					}, {
						name:  "STRIMZI_DEFAULT_CRUISE_CONTROL_IMAGE"
						value: "quay.io/strimzi/kafka:0.26.0-kafka-3.0.0"
					}, {
						name:  "STRIMZI_DEFAULT_TLS_SIDECAR_CRUISE_CONTROL_IMAGE"
						value: "quay.io/strimzi/kafka:0.26.0-kafka-3.0.0"
					}, {
						name: "STRIMZI_KAFKA_IMAGES"
						value: """
									2.8.0=quay.io/strimzi/kafka:0.26.0-kafka-2.8.0
									2.8.1=quay.io/strimzi/kafka:0.26.0-kafka-2.8.1
									3.0.0=quay.io/strimzi/kafka:0.26.0-kafka-3.0.0

									"""
					}, {
						name: "STRIMZI_KAFKA_CONNECT_IMAGES"
						value: """
									2.8.0=quay.io/strimzi/kafka:0.26.0-kafka-2.8.0
									2.8.1=quay.io/strimzi/kafka:0.26.0-kafka-2.8.1
									3.0.0=quay.io/strimzi/kafka:0.26.0-kafka-3.0.0

									"""
					}, {
						name: "STRIMZI_KAFKA_MIRROR_MAKER_IMAGES"
						value: """
									2.8.0=quay.io/strimzi/kafka:0.26.0-kafka-2.8.0
									2.8.1=quay.io/strimzi/kafka:0.26.0-kafka-2.8.1
									3.0.0=quay.io/strimzi/kafka:0.26.0-kafka-3.0.0

									"""
					}, {
						name: "STRIMZI_KAFKA_MIRROR_MAKER_2_IMAGES"
						value: """
									2.8.0=quay.io/strimzi/kafka:0.26.0-kafka-2.8.0
									2.8.1=quay.io/strimzi/kafka:0.26.0-kafka-2.8.1
									3.0.0=quay.io/strimzi/kafka:0.26.0-kafka-3.0.0

									"""
					}, {
						name:  "STRIMZI_DEFAULT_TOPIC_OPERATOR_IMAGE"
						value: "quay.io/strimzi/operator:0.26.0"
					}, {
						name:  "STRIMZI_DEFAULT_USER_OPERATOR_IMAGE"
						value: "quay.io/strimzi/operator:0.26.0"
					}, {
						name:  "STRIMZI_DEFAULT_KAFKA_INIT_IMAGE"
						value: "quay.io/strimzi/operator:0.26.0"
					}, {
						name:  "STRIMZI_DEFAULT_KAFKA_BRIDGE_IMAGE"
						value: "quay.io/strimzi/kafka-bridge:0.20.3"
					}, {
						name:  "STRIMZI_DEFAULT_JMXTRANS_IMAGE"
						value: "quay.io/strimzi/jmxtrans:0.26.0"
					}, {
						name:  "STRIMZI_DEFAULT_KANIKO_EXECUTOR_IMAGE"
						value: "quay.io/strimzi/kaniko-executor:0.26.0"
					}, {
						name:  "STRIMZI_DEFAULT_MAVEN_BUILDER"
						value: "quay.io/strimzi/maven-builder:0.26.0"
					}, {
						name: "STRIMZI_OPERATOR_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						name:  "STRIMZI_FEATURE_GATES"
						value: ""
					}]
					livenessProbe: {
						httpGet: {
							path: "/healthy"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       30
					}
					readinessProbe: {
						httpGet: {
							path: "/ready"
							port: "http"
						}
						initialDelaySeconds: 10
						periodSeconds:       30
					}
					resources: {
						limits: {
							cpu:    "1000m"
							memory: "384Mi"
						}
						requests: {
							cpu:    "200m"
							memory: "384Mi"
						}
					}
				}]
			}
		}
		strategy: type: "Recreate"
	}
}
