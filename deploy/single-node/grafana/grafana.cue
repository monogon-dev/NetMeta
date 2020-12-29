package k8s

import (
	"encoding/yaml"
	"crypto/sha1"
	"encoding/hex"
	"strings"
	"strconv"
)

// https://github.com/grafana/grafana/blob/master/docs/sources/administration/provisioning.md
#DatasourceConfig: {
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
datasource_config: #DatasourceConfig & {
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
						image:           "docker.io/grafana/grafana:7.3.6@sha256:05bc2b08de2a6cd6260937dc174cc4bdfada29cc7dd13c73e638caad32d26b3e"
						imagePullPolicy: "IfNotPresent"

						_googleAuth: [...]

						if netmeta.config.grafanaGoogleAuth.clientID != "" {
							_googleAuth: [
								{
									name:  "GF_AUTH_GOOGLE_ENABLED"
									value: "true"
								},
								{
									name:  "GF_AUTH_GOOGLE_CLIENT_ID"
									value: netmeta.config.grafanaGoogleAuth.clientID
								},
								{
									name:  "GF_AUTH_GOOGLE_CLIENT_SECRET"
									value: netmeta.config.grafanaGoogleAuth.clientSecret
								},
								{
									name:  "GF_AUTH_GOOGLE_SCOPES"
									value: "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email"
								},
								{
									name:  "GF_AUTH_GOOGLE_AUTH_URL"
									value: "https://accounts.google.com/o/oauth2/auth"
								},
								{
									name:  "GF_AUTH_GOOGLE_TOKEN_URL"
									value: "https://accounts.google.com/o/oauth2/token"
								},
								{
									name:  "GF_AUTH_GOOGLE_ALLOWED_DOMAINS"
									value: strings.Join(netmeta.config.grafanaGoogleAuth.allowedDomains, " ")
								},
								{
									name:  "GF_AUTH_GOOGLE_ALLOW_SIGN_UP"
									value: strconv.FormatBool(netmeta.config.grafanaGoogleAuth.allowSignup)
								},
							]
						}

						env: [
							{
								name:  "GF_SERVER_ROOT_URL"
								value: "https://\(netmeta.config.publicHostname)"
							},
							{
								name:  "GF_INSTALL_PLUGINS"
								value: "vertamedia-clickhouse-datasource 1.9.5"
							},
							{
								name:  "GF_SECURITY_ADMIN_PASSWORD"
								value: netmeta.config.grafanaInitialAdminPassword
							},
							{
								name:  "GF_AUTH_BASIC_ENABLED"
								value: strconv.FormatBool(netmeta.config.grafanaBasicAuth)
							},
							{
								name:  "GF_AUTH_OAUTH_AUTO_LOGIN"
								value: strconv.FormatBool(!netmeta.config.grafanaBasicAuth)
							},
							{
								name:  "GF_SECURITY_SECRET_KEY"
								value: netmeta.config.sessionSecret
							},
							{
								name:  "GF_SECURITY_DISABLE_GRAVATAR"
								value: "true"
							},
							{
								name:  "GF_SESSION_COOKIE_SECURE"
								value: "true"
							},
							{
								name:  "GF_SECURITY_COOKIE_SECURE"
								value: "true"
							},
							{
								name:  "GF_SECURITY_STRICT_TRANSPORT_SECURITY"
								value: "true"
							},
							{
								name:  "GF_USERS_AUTO_ASSIGN_ORG_ROLE"
								value: netmeta.config.grafanaDefaultRole
							},
							{
								name:  "GF_ANALYTICS_CHECK_FOR_UPDATES"
								value: "false"
							},
						] + _googleAuth

						ports: [{
							containerPort: 3000
							protocol:      "TCP"
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
