package clickhouse_queries

dashboards: "ClickHouse Queries": {
	templating: list: [{
		current: {
			selected: false
			text:     "NetMeta ClickHouse"
			value:    "NetMeta ClickHouse"
		}
		hide:       0
		includeAll: false
		label:      "Datasource"
		multi:      false
		name:       "datasource"
		query:      "vertamedia-clickhouse-datasource"
		regex:      ""
		type:       "datasource"
	}]
	annotations: list: [
		{
			builtIn:    1
			datasource: "-- Grafana --"
			enable:     true
			hide:       true
			iconColor:  "rgba(0, 211, 255, 1)"
			name:       "Annotations & Alerts"
			type:       "dashboard"
		},
	]
	editable:     true
	gnetId:       null
	graphTooltip: 0
	id:           null
	links: []
	panels: [
		{
			datasource: "$datasource"
			fieldConfig: {
				defaults: {
					custom: align: null
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
								value: null
							},
							{
								color: "red"
								value: 80
							},
						]
					}
					unit: "short"
				}
				overrides: [
					{
						matcher: {
							id:      "byName"
							options: "elapsed"
						}
						properties: [
							{
								id:    "unit"
								value: "s"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "read_bytes"
						}
						properties: [
							{
								id:    "unit"
								value: "bytes"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "memory_usage"
						}
						properties: [
							{
								id:    "unit"
								value: "bytes"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "peak_memory_usage"
						}
						properties: [
							{
								id:    "unit"
								value: "bytes"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "read_progress"
						}
						properties: [
							{
								id:    "unit"
								value: "percentunit"
							},
							{
								id:    "custom.displayMode"
								value: "gradient-gauge"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "write_progress"
						}
						properties: [
							{
								id:    "unit"
								value: "percentunit"
							},
							{
								id:    "custom.displayMode"
								value: "gradient-gauge"
							},
						]
					},
				]
			}
			gridPos: {
				h: 13
				w: 24
				x: 0
				y: 0
			}
			id: 2
			options: showHeader: true
			pluginVersion: "7.0.0"
			targets: [
				{
					dateTimeType:   "DATETIME"
					format:         "table"
					formattedQuery: "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					intervalFactor: 1
					query:          "SELECT\n    initial_user,\n    initial_query_id,\n    elapsed,\n    read_rows,\n    read_bytes,\n    total_rows_approx,\n    written_rows,\n    written_bytes,\n    memory_usage,\n    peak_memory_usage,\n    query,\n    read_rows / total_rows_approx AS read_progress,\n    written_rows / total_rows_approx AS write_progress\nFROM system.processes"
					refId:          "A"
					round:          "0s"
				},
			]
			timeFrom:  null
			timeShift: null
			title:     "Running Processes"
			type:      "table"
		},
		{
			datasource: "$datasource"
			fieldConfig: {
				defaults: {
					custom: align: null
					mappings: []
					thresholds: {
						mode: "absolute"
						steps: [
							{
								color: "green"
								value: null
							},
							{
								color: "red"
								value: 80
							},
						]
					}
					unit: "short"
				}
				overrides: [
					{
						matcher: {
							id:      "byName"
							options: "query_duration_ms"
						}
						properties: [
							{
								id:    "unit"
								value: "ms"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "read_bytes"
						}
						properties: [
							{
								id:    "unit"
								value: "bytes"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "memory_usage"
						}
						properties: [
							{
								id:    "unit"
								value: "kbytes"
							},
							{
								id:    "custom.displayMode"
								value: "gradient-gauge"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "written_bytes"
						}
						properties: [
							{
								id:    "unit"
								value: "bytes"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "result_bytes"
						}
						properties: [
							{
								id:    "unit"
								value: "bytes"
							},
						]
					},
					{
						matcher: {
							id:      "byName"
							options: "query"
						}
						properties: [
							{
								id:    "custom.displayMode"
								value: "json-view"
							},
						]
					},
				]
			}
			gridPos: {
				h: 26
				w: 24
				x: 0
				y: 13
			}
			id: 3
			options: showHeader: true
			pluginVersion: "7.0.0"
			targets: [
				{
					dateTimeType:   "DATETIME"
					format:         "table"
					formattedQuery: "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					intervalFactor: 1
					query:          "SELECT\n    event_time,\n    user,\n    query_id,\n    query_duration_ms,\n    read_rows,\n    read_bytes,\n    written_rows,\n    written_bytes,\n    memory_usage / 1024 AS memory_usage,\n    query,\n    exception\nFROM system.query_log\nWHERE type = 'QueryFinish' AND query NOT LIKE '%FROM system.%'\nORDER BY event_time DESC\nLIMIT 100"
					refId:          "A"
					round:          "0s"
				},
			]
			timeFrom:  null
			timeShift: null
			title:     "Finished Queries (except system queries)"
			type:      "table"
		},
	]
	refresh:       "5s"
	schemaVersion: 25
	style:         "dark"
	tags: []
	time: {
		from: "now-5m"
		to:   "now"
	}
	timepicker: refresh_intervals: [
		"10s",
		"30s",
		"1m",
		"5m",
		"15m",
		"30m",
		"1h",
		"2h",
		"1d",
	]
	timezone: ""
	uid:      "ruVFH2kGk"
	version:  12
}
