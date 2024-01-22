package nix

import (
	// Dashboards
	grafana_dashboards "github.com/monogon-dev/NetMeta/deploy/dashboards"
	schema "github.com/monogon-dev/NetMeta/deploy/single-node/schema"
	clickhouse "github.com/monogon-dev/NetMeta/deploy/base/clickhouse"
	reconciler "github.com/monogon-dev/NetMeta/reconciler:main"

	"encoding/json"
)

netmeta: config: #NetMetaConfig
netmeta: dashboards: {
	_dashboards: (grafana_dashboards & {
		#Config: netmeta.config.dashboardDisplay
	})
	for k, v in _dashboards.dashboards {
		"\(k)": v
	}
}

_schema: (schema & {
	#Config: {
		sampler:         netmeta.config.sampler
		kafkaBrokerList: netmeta.config.deployment.nix.kafkaBrokerList
	}
})

out: dashboards: netmeta.dashboards

out: "clickhouse": (clickhouse & {
	#Config: {
		sampler:    netmeta.config.sampler
		userData:   netmeta.config.userData
		risinfoURL: netmeta.config.deployment.nix.risinfoURL
		dataPath:   netmeta.config.deployment.nix.dataPath
	}
})

out: "reconciler": {
	for name, content in _schema.file {
		"\(name)": content
	}
	"config.json": json.Marshal(reconciler.#Config & {
		database: "default"
		functions: [for _, v in _schema.function {v}]
		materialized_views: [for _, v in _schema.view {v}]
		source_tables: [for _, v in _schema.table {v}]
	})
}
