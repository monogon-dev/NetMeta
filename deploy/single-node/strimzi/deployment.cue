package k8s

k8s: deployments: "strimzi-cluster-operator": spec: {
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
			containers: [{
				name:  "strimzi-cluster-operator"
				image: "docker.io/strimzi/operator:0.17.0@sha256:a789a21d93e73fb2fcc1981e721697296696f8900c7dd7a018838f54e62ea0ac"
				args: [
					"/opt/strimzi/bin/cluster_operator_run.sh",
				]

				_kafka_image:  "docker.io/strimzi/kafka:0.17.0-kafka-2.4.0@sha256:de664b7bfed6558da4c68dd9c010f20034a3ce1840bc47cfe91fc6f75b736065"
				_kafka_images: "2.3.1=strimzi/kafka:0.17.0-kafka-2.3.1\n2.4.0=\(_kafka_image)"

				_operator_image: "docker.io/strimzi/operator:0.17.0@sha256:a789a21d93e73fb2fcc1981e721697296696f8900c7dd7a018838f54e62ea0ac"

				_bridge_image: "docker.io/strimzi/kafka-bridge:0.15.2@sha256:dcbb883ab47350ac6bff61f20d7cf645fdc08878b6d5f29f3bda391e809435d0"

				_jmxtrans_image: "docker.io/strimzi/jmxtrans:0.17.0@sha256:87b0f75c84c72472eb91a0960bc8427578dffea5da01d46215d365bb0198fd40"

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
					value: _kafka_image
				}, {
					name:  "STRIMZI_DEFAULT_TLS_SIDECAR_KAFKA_IMAGE"
					value: _kafka_image
				}, {
					name:  "STRIMZI_DEFAULT_TLS_SIDECAR_ZOOKEEPER_IMAGE"
					value: _kafka_image
				}, {
					name:  "STRIMZI_DEFAULT_KAFKA_EXPORTER_IMAGE"
					value: _kafka_image
				}, {
					name:  "STRIMZI_KAFKA_IMAGES"
					value: _kafka_images
				}, {
					name:  "STRIMZI_KAFKA_CONNECT_IMAGES"
					value: _kafka_images
				}, {
					name:  "STRIMZI_KAFKA_CONNECT_S2I_IMAGES"
					value: _kafka_images
				}, {
					name:  "STRIMZI_KAFKA_MIRROR_MAKER_IMAGES"
					value: _kafka_images
				}, {
					name:  "STRIMZI_KAFKA_MIRROR_MAKER_2_IMAGES"
					value: _kafka_images
				}, {
					name:  "STRIMZI_DEFAULT_TOPIC_OPERATOR_IMAGE"
					value: _operator_image
				}, {
					name:  "STRIMZI_DEFAULT_USER_OPERATOR_IMAGE"
					value: _operator_image
				}, {
					name:  "STRIMZI_DEFAULT_KAFKA_INIT_IMAGE"
					value: _operator_image
				}, {
					name:  "STRIMZI_DEFAULT_KAFKA_BRIDGE_IMAGE"
					value: _bridge_image
				}, {
					name:  "STRIMZI_DEFAULT_JMXTRANS_IMAGE"
					value: _jmxtrans_image
				}, {
					name:  "STRIMZI_LOG_LEVEL"
					value: "INFO"
				}, {
					name:  "JAVA_OPTS"
					value:  "-Dlog4j2.formatMsgNoLookups=true"
				}]
				livenessProbe: {
					httpGet: {
						path: "/healthy"
						port: 8080
					}
					initialDelaySeconds: 10
					periodSeconds:       30
				}
				readinessProbe: {
					httpGet: {
						path: "/ready"
						port: 8080
					}
					initialDelaySeconds: 10
					periodSeconds:       30
				}
				resources: {
					limits: {
						cpu:    "1000m"
						memory: "256Mi"
					}
					requests: {
						cpu:    "200m"
						memory: "256Mi"
					}
				}
			}]
		}
	}
	strategy: type: "Recreate"
}
