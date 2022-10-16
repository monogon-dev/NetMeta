package clickhouse

import (
	"crypto/sha256"
	"encoding/hex"
)

#InterfaceMap: {
	// Router source address (IPv6 or pseudo-IPv4 mapped address like ::100.0.0.1, and for the portmirror ::ffff:100.0.0.1)
	device: string
	// Numeric interface Index (often known as the "SNMP ID")
	idx: uint
	// Human-readable interface description to show in the frontend
	description: string
}

#Config: {
	clickhouseAdminPassword: string
	enableClickhouseIngress: bool
	publicHostname:          string
	interfaceMap: [...#InterfaceMap]
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
			format_schema_path:  "/etc/clickhouse-server/config.d/"
			dictionaries_config: "config.d/*.conf"
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
			"admin/password_sha256_hex": hex.Encode(sha256.Sum256(#Config.clickhouseAdminPassword))
			"admin/networks/ip":         "::/0"
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
					image: "docker.io/clickhouse/clickhouse-server:22.6.9.11-alpine@sha256:1209d9a2a345cbbd6a9c6f02d4b0bde914e221d28c684091df2e539881d8c064"
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
				match: "Host(`\(#Config.publicHostname)`) && PathPrefix(`/`)"
				kind:  "Rule"
				services: [
					{
						name: "clickhouse-netmeta"
						port: 8123
					},
				]
			},
		]
	}
}
