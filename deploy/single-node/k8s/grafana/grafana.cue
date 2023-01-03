package grafana

import (
	"encoding/yaml"
	"encoding/json"
	"crypto/sha1"
	"encoding/hex"
	"strings"
	"strconv"
)

#Config: {
	publicHostname:              string
	grafanaInitialAdminPassword: string
	grafanaBasicAuth:            bool
	sessionSecret:               string
	grafanaDefaultRole:          string
	clickhouseReadonlyPassword:  string

	dashboards: [string]: _

	fastNetMon?: dataSource: string
	grafanaGoogleAuth?: {
		clientID:     string
		clientSecret: string
		allowedDomains: [string, ...string]
		allowSignup: bool
	}

}

// https://github.com/grafana/grafana/blob/master/docs/sources/administration/provisioning.md
#DatasourceConfig: {
	apiVersion: 1
	datasources: [...{
		name:      string
		type:      string
		url?:      string
		access:    *"proxy" | "direct"
		user?:     string
		isDefault: *false | bool
		basicAuth: *false | bool
		secureJsonData?: password: string
		jsonData: {...}
	}]
}

// https://github.com/grafana/grafana/blob/master/docs/sources/administration/provisioning.md
#DashboardConfig: {
	apiVersion: 1
	providers: [...{
		name: string

		ordId: uint | *1

		folder?:    string
		folderUid?: string

		type: "file"

		disableDeletion: *true | bool
		allowUiUpdates:  *true | bool

		updateIntervalSeconds: uint | *1

		options: path: string

		options: foldersFromFilesStructure: true
	}]
}

PersistentVolumeClaim: "grafana-data-claim": {}

// Default prometheus config
ConfigMap: "grafana-datasources": data: "datasources.yaml": yaml.Marshal(#DatasourceConfig & {
	datasources: [
		{
			name: "Local Prometheus"
			type: "prometheus"
			url:  "http://prometheus:9090"
		},
		{
			isDefault: false
			name:      "NetMeta ClickHouse"
			type:      "vertamedia-clickhouse-datasource"
			url:       "http://clickhouse-netmeta:8123"
			// Workaround for:
			// https://github.com/Vertamedia/clickhouse-grafana/blob/1c736969cdac2e5858e5d1870480c2d2f5e59c0a/datasource.go#L81-L88
			jsonData: {
				useYandexCloudAuthorization: true
				xHeaderUser:                 "readonly"
				xHeaderKey:                  #Config.clickhouseReadonlyPassword
			}
		},
		{
			isDefault: false
			name:      "ClickHouse"
			type:      "grafana-clickhouse-datasource"
			jsonData: {
				defaultDatabase: "default"
				port:            8123
				protocol:        "http"
				server:          "clickhouse-netmeta"
				username:        "readonly"
			}
			secureJsonData: password: #Config.clickhouseReadonlyPassword
		},
	]
})

ConfigMap: "grafana-dashboards": data: "dashboards.yaml": yaml.Marshal(#DashboardConfig & {
	providers: [
		{
			name:   "NetMeta Dashboards"
			folder: "NetMeta"
			options: path: "/var/lib/grafana/dashboards"
		},
	]
})

// Generated dashboards
ConfigMap: "grafana-dashboards-data": data: {
	for k, v in #Config.dashboards {
		"\(strings.ToLower(strings.Replace(k, " ", "_", -1))).json": json.Indent(json.Marshal(v), "", " ")
	}
}

Service: grafana: spec: {
	ports: [{
		name:       "grafana"
		protocol:   "TCP"
		port:       80
		targetPort: 3000
	}]
	selector: app: "grafana"
}

StatefulSet: grafana: spec: {
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
			annotations: configHash: hex.Encode(sha1.Sum(ConfigMap["grafana-datasources"].data["datasources.yaml"]))
		}
		spec: {
			containers: [
				{
					name:            "grafana"
					image:           "docker.io/grafana/grafana:9.2.0@sha256:ff2663d4f014903a70a8446e55131b69041bc259066d6115e158de4ee8bc67a2"
					imagePullPolicy: "IfNotPresent"

					_googleAuth: [...]

					if #Config.grafanaGoogleAuth != _|_ {
						_googleAuth: [
							{
								name:  "GF_AUTH_GOOGLE_ENABLED"
								value: "true"
							},
							{
								name:  "GF_AUTH_GOOGLE_CLIENT_ID"
								value: #Config.grafanaGoogleAuth.clientID
							},
							{
								name:  "GF_AUTH_GOOGLE_CLIENT_SECRET"
								value: #Config.grafanaGoogleAuth.clientSecret
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
								value: strings.Join(#Config.grafanaGoogleAuth.allowedDomains, " ")
							},
							{
								name:  "GF_AUTH_GOOGLE_ALLOW_SIGN_UP"
								value: strconv.FormatBool(#Config.grafanaGoogleAuth.allowSignup)
							},
						]
					}

					env: [
						{
							name:  "GF_SERVER_ROOT_URL"
							value: "https://\(#Config.publicHostname)"
						},
						{
							name:  "GF_INSTALL_PLUGINS"
							value: "vertamedia-clickhouse-datasource 2.5.2,netsage-sankey-panel 1.0.6,grafana-clickhouse-datasource 2.0.5"
						},
						{
							name:  "GF_SECURITY_ADMIN_PASSWORD"
							value: #Config.grafanaInitialAdminPassword
						},
						{
							name:  "GF_AUTH_BASIC_ENABLED"
							value: strconv.FormatBool(#Config.grafanaBasicAuth)
						},
						{
							name:  "GF_AUTH_OAUTH_AUTO_LOGIN"
							value: strconv.FormatBool(!#Config.grafanaBasicAuth)
						},
						{
							name:  "GF_SECURITY_SECRET_KEY"
							value: #Config.sessionSecret
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
							value: #Config.grafanaDefaultRole
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
					volumeMounts: [
						{
							mountPath: "/var/lib/grafana"
							name:      "grafana-data"
						},
						{
							mountPath: "/etc/grafana/provisioning/datasources"
							name:      "grafana-datasources"
						},
						{
							mountPath: "/etc/grafana/provisioning/dashboards"
							name:      "grafana-dashboards"
						},
						{
							mountPath: "/var/lib/grafana/dashboards"
							name:      "grafana-dashboards-data"
						},
					]
				},
			]
			restartPolicy: "Always"
			volumes: [
				{
					name: "grafana-datasources"
					configMap: name: "grafana-datasources"
				},
				{
					name: "grafana-dashboards"
					configMap: name: "grafana-dashboards"
				},
				{
					name: "grafana-dashboards-data"
					configMap: name: "grafana-dashboards-data"
				},
				{
					name: "grafana-data"
					persistentVolumeClaim: claimName: "grafana-data-claim"
				},
			]
		}
	}
}
