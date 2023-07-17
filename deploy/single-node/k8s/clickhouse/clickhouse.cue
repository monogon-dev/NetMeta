package clickhouse

import (
	"crypto/sha256"
	"encoding/hex"
)

// A stripped down version of the #SamplerConfig found in deploy/single-node/config.cue
#SamplerConfig: [string]: {
	device:             string
	samplingRate:       int
	anonymizeAddresses: bool
	description:        string
	interface: [string]: {
		id:          int
		description: string
	}
	vlan: [string]: {
		id:          int
		description: string
	}
	host: [string]: {
		device:      string
		description: string
	}
	...
}

#UserData: {
	autnums: [string]: {
		asn:     int
		name:    string
		country: string
	}
}

#Config: {
	clickhouseAdminPassword:    string
	clickhouseReadonlyPassword: string
	enableClickhouseIngress:    bool
	sampler:                    #SamplerConfig
	userData:                   #UserData
}

ClickHouseInstallation: netmeta: spec: {
	defaults: templates: {
		dataVolumeClaimTemplate: "local-pv"
		logVolumeClaimTemplate:  "local-pv"
		serviceTemplate:         "chi-service-internal"
		podTemplate:             "clickhouse-static"
	}
	configuration: {
		settings: {
			format_schema_path:                                                  "/etc/clickhouse-server/config.d/"
			dictionaries_config:                                                 "config.d/*.conf"
			user_defined_executable_functions_config:                            "config.d/*_function.xml"
			http_port:                                                           8123
			"access_control_improvements/settings_constraints_replace_previous": true
		}
		clusters: [
			{
				name: "netmeta"
				layout: {
					shardsCount:   1
					replicasCount: 1
				}
			},
		]
		users: {
			"default/access_management":    1
			"admin/password_sha256_hex":    hex.Encode(sha256.Sum256(#Config.clickhouseAdminPassword))
			"admin/networks/ip":            "::/0"
			"readonly/password_sha256_hex": hex.Encode(sha256.Sum256(#Config.clickhouseReadonlyPassword))
			"readonly/networks/ip":         "::/0"
			"readonly/profile":             "readonly"
		}
		profiles: {
			"readonly/readonly":                                                    "1"
			"readonly/constraints/additional_table_filters/changeable_in_readonly": ""
		}
		files: [string]: string
	}
	templates: {
		volumeClaimTemplates: [{
			name: "local-pv"
			spec: {
				accessModes: [
					"ReadWriteOnce",
				]
				resources: requests: storage: "100Gi"
			}
		}]
		serviceTemplates: [{
			name:         "chi-service-internal"
			generateName: "clickhouse-{chi}"
			spec: ports: [
				{name: "http", port: 8123, targetPort: port, protocol: "TCP"},
				{name: "tcp", port:  9000, targetPort: port, protocol: "TCP"},
			]
		}]
		podTemplates: [{
			name: "clickhouse-static"
			spec: {
				securityContext: {
					runAsUser:  101
					runAsGroup: 101
					fsGroup:    101
				}
				containers: [{
					name:  "clickhouse"
					image: "docker.io/clickhouse/clickhouse-server:23.2.4.12-alpine@sha256:0a63183a4da2923868cc0e58285e404a4a60e1be657c5b7005e736e91cfd4da9"
					resources: {}
				}]
			}
		}]
	}
}

if #Config.enableClickhouseIngress {
	IngressRoute: "clickhouse-ingress": spec: {
		entryPoints: ["clickhouse"]
		routes: [
			{
				match: "PathPrefix(`/`)"
				kind:  "Rule"
				services: [
					{
						name: "clickhouse-netmeta"
						port: "http"
					},
				]
			},
		]
	}
}
