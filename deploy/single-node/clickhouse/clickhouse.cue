package k8s

import (
	"crypto/sha256"
	"encoding/hex"
)

let config = netmeta.config

k8s: clickhouseinstallations: netmeta: spec: {
	defaults: templates: {
		dataVolumeClaimTemplate: "local-pv"
		logVolumeClaimTemplate:  "local-pv"
		serviceTemplate:         "chi-service-internal"
		podTemplate:             "clickhouse-static"
	}
	configuration: {
		settings: {
			"format_schema_path":  "/etc/clickhouse-server/config.d/"
			"dictionaries_config": "/etc/clickhouse-server/config.d/*.dict"
		}
		clusters: [
			{
				name: "netmeta"
				templates: {}
				zookeeper: {}
				address: {}
				layout: {
					shardsCount:   1
					replicasCount: 1
				}
			},
		]
		users: {
			"clickhouse_operator/password_sha256_hex": hex.Encode(sha256.Sum256(config.clickhouseOperatorPassword))
		}
	}
	templates: {
		volumeClaimTemplates: [{
			name:          "local-pv"
			reclaimPolicy: ""
			spec: {
				accessModes: [
					"ReadWriteOnce",
				]
				dataSource: null
				resources: requests: storage: "100Gi"
			}
		}]
		serviceTemplates: [{
			name:         "chi-service-internal"
			generateName: "clickhouse-{chi}"
			spec: ports: [
				{name: "http", port: 8123, protocol: "TCP"},
				{name: "tcp", port:  9000, protocol: "TCP"},
			]
		}]
		podTemplates: [{
			name: "clickhouse-static"
			spec: containers: [{
				name:  "clickhouse"
				image: "yandex/clickhouse-server:20.3.10.75"
			}]
		}]
	}
}
