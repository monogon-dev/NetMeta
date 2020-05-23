package k8s

import (
	"encoding/yaml"
	"crypto/sha1"
	"encoding/hex"
)

// https://github.com/grafana/grafana/blob/master/docs/sources/administration/provisioning.md
DatasourceConfig :: {
	apiVersion: 1
	datasources: [...{
		name:      string
		type:      string
		url:       string
		access:    *"proxy" | "direct"
		user?:     string
		isDefault: *false | bool
		basicAuth: *false | bool
		secureJsonData?: password: string
		jsonData: {...}
	}]
}

// Default prometheus config
datasource_config: DatasourceConfig & {
	datasources: [
		{
			name: "Local Prometheus"
			type: "prometheus"
			url:  "http://prometheus:9090"
		},
		{
			isDefault: true
			name:      "NetMeta ClickHouse"
			type:      "vertamedia-clickhouse-datasource"
			url:       "http://clickhouse-netmeta:8123"
			// Workaround for:
			// https://github.com/Vertamedia/clickhouse-grafana/blob/1c736969cdac2e5858e5d1870480c2d2f5e59c0a/datasource.go#L81-L88
			jsonData: {
				useYandexCloudAuthorization: true
				xHeaderUser:                 "clickhouse_operator"
				xHeaderKey:                  netmeta.config.clickhouseOperatorPassword
			}
		},
	]
}

k8s: {
	pvcs: "grafana-data-claim": {}

	configmaps: "grafana-datasources": data: "datasources.yaml": yaml.Marshal(datasource_config)

	services: grafana: spec: {
		ports: [{
			name:       "grafana"
			protocol:   "TCP"
			port:       80
			targetPort: 3000
		}]
		selector: app: "grafana"
	}

	statefulsets: grafana: spec: {
		updateStrategy: type: "RollingUpdate"
		podManagementPolicy: "Parallel"
		selector: matchLabels: app: "grafana"
		serviceName: "grafana"
		template: {
			metadata: {
				labels: app: "grafana"
				name: "grafana"
				// Force redeployment when datasource config is modified
				// https://github.com/kubernetes/kubernetes/issues/22368
				annotations: configHash: hex.Encode(sha1.Sum(yaml.Marshal(datasource_config)))
			}
			spec: {
				containers: [
					{
						name:            "grafana"
						image:           "grafana/grafana:7.0.0"
						imagePullPolicy: "IfNotPresent"
						env: [
							{
								name:  "GF_INSTALL_PLUGINS"
								value: "vertamedia-clickhouse-datasource 1.9.5"
							},
							{
								name:  "GF_SECURITY_ADMIN_PASSWORD"
								value: "\(netmeta.config.grafanaInitialAdminPassword)"
							},
						]
						ports: [{
							containerPort: 3000
							name:          "grafana"
						}]
						volumeMounts: [{
							mountPath: "/var/lib/grafana"
							name:      "grafana-data"
						}, {
							mountPath: "/etc/grafana/provisioning/datasources"
							name:      "grafana-datasources"
						}]
					},
				]
				restartPolicy: "Always"
				volumes: [{
					name: "grafana-datasources"
					configMap: name: "grafana-datasources"
				}, {
					name: "grafana-data"
					persistentVolumeClaim: claimName: "grafana-data-claim"
				}]
			}
		}
	}
}
