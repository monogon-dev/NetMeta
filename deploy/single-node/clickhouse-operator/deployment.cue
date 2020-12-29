package k8s

k8s: deployments: "clickhouse-operator": {
	metadata: labels: app: "clickhouse-operator"
	spec: {
		replicas: 1
		selector: matchLabels: app: "clickhouse-operator"
		template: {
			metadata: {
				labels: app: "clickhouse-operator"
				annotations: {
					"prometheus.io/port":   "8888"
					"prometheus.io/scrape": "true"
				}
			}
			spec: {
				serviceAccountName: "clickhouse-operator"
				volumes: [{
					name: "etc-clickhouse-operator-folder"
					configMap: name: "etc-clickhouse-operator-files"
				}, {
					name: "etc-clickhouse-operator-confd-folder"
					configMap: name: "etc-clickhouse-operator-confd-files"
				}, {
					name: "etc-clickhouse-operator-configd-folder"
					configMap: name: "etc-clickhouse-operator-configd-files"
				}, {
					name: "etc-clickhouse-operator-templatesd-folder"
					configMap: name: "etc-clickhouse-operator-templatesd-files"
				}, {
					name: "etc-clickhouse-operator-usersd-folder"
					configMap: name: "etc-clickhouse-operator-usersd-files"
				}]
				containers: [{
					name:            "clickhouse-operator"
					image:           "docker.io/altinity/clickhouse-operator:0.9.9@sha256:08f2a6b0a2102e4599fe816f9f26e0f43eba1b1cd8b6b72df5534f89ce648071"
					imagePullPolicy: "Always"
					volumeMounts: [{
						name:      "etc-clickhouse-operator-folder"
						mountPath: "/etc/clickhouse-operator"
					}, {
						name:      "etc-clickhouse-operator-confd-folder"
						mountPath: "/etc/clickhouse-operator/conf.d"
					}, {
						name:      "etc-clickhouse-operator-configd-folder"
						mountPath: "/etc/clickhouse-operator/config.d"
					}, {
						name:      "etc-clickhouse-operator-templatesd-folder"
						mountPath: "/etc/clickhouse-operator/templates.d"
					}, {
						name:      "etc-clickhouse-operator-usersd-folder"
						mountPath: "/etc/clickhouse-operator/users.d"
					}]
					env: [{
						// Pod-specific
						// spec.nodeName: ip-172-20-52-62.ec2.internal
						name: "OPERATOR_POD_NODE_NAME"
						valueFrom: fieldRef: fieldPath: "spec.nodeName"
					}, {
						// metadata.name: clickhouse-operator-6f87589dbb-ftcsf
						name: "OPERATOR_POD_NAME"
						valueFrom: fieldRef: fieldPath: "metadata.name"
					}, {
						// metadata.namespace: kube-system
						name: "OPERATOR_POD_NAMESPACE"
						valueFrom: fieldRef: fieldPath: "metadata.namespace"
					}, {
						// status.podIP: 100.96.3.2
						name: "OPERATOR_POD_IP"
						valueFrom: fieldRef: fieldPath: "status.podIP"
					}, {
						// spec.serviceAccount: clickhouse-operator
						// spec.serviceAccountName: clickhouse-operator
						name: "OPERATOR_POD_SERVICE_ACCOUNT"
						valueFrom: fieldRef: fieldPath: "spec.serviceAccountName"
					}, {
						// Container-specific
						name: "OPERATOR_CONTAINER_CPU_REQUEST"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "requests.cpu"
						}
					}, {
						name: "OPERATOR_CONTAINER_CPU_LIMIT"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "limits.cpu"
						}
					}, {
						name: "OPERATOR_CONTAINER_MEM_REQUEST"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "requests.memory"
						}
					}, {
						name: "OPERATOR_CONTAINER_MEM_LIMIT"
						valueFrom: resourceFieldRef: {
							containerName: "clickhouse-operator"
							resource:      "limits.memory"
						}
					}]
				}, {
					name:            "metrics-exporter"
					image:           "docker.io/altinity/metrics-exporter:0.9.7@sha256:876010545d56a9fc705b2006b73f2bcd39c3afe73cc3aa2f78c9ac34d0b58b09"
					imagePullPolicy: "Always"
					volumeMounts: [{
						name:      "etc-clickhouse-operator-folder"
						mountPath: "/etc/clickhouse-operator"
					}, {
						name:      "etc-clickhouse-operator-confd-folder"
						mountPath: "/etc/clickhouse-operator/conf.d"
					}, {
						name:      "etc-clickhouse-operator-configd-folder"
						mountPath: "/etc/clickhouse-operator/config.d"
					}, {
						name:      "etc-clickhouse-operator-templatesd-folder"
						mountPath: "/etc/clickhouse-operator/templates.d"
					}, {
						name:      "etc-clickhouse-operator-usersd-folder"
						mountPath: "/etc/clickhouse-operator/users.d"
					}]
				}]
			}
		}
	}
}
