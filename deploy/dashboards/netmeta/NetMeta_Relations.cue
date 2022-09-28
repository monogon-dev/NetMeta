package netmeta

dashboards: "Traffic Relations": {
	editable:             true
	fiscalYearStartMonth: 0
	graphTooltip:         1
	id:                   21
	links: []
	liveNow: false
	panels: [
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			gridPos: {
				h: 3
				w: 5
				x: 19
				y: 0
			}
			id:       44
			interval: "40s"
			options: {
				content: "This dashboard is provisioned automatically and will be overwritten when you update NetMeta. If you want to make persistent changes, please create a copy."
				mode:    "markdown"
			}
			panels: []
			targets: [
				{
					datasource: "$datasource"
					queryType:  "randomWalk"
					refId:      "A"
				},
			]
			title: "This is a preprovisioned dashboard"
			type:  "text"
		},
		{
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 3
			}
			id:    61
			title: "Top AS"
			type:  "row"
		},
		{
			aliasColors: {}
			bars:       false
			dashLength: 10
			dashes:     false
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			fieldConfig: {
				defaults: links: []
				overrides: []
			}
			fill:         1
			fillGradient: 0
			gridPos: {
				h: 12
				w: 12
				x: 0
				y: 4
			}
			hiddenSeries: false
			id:           59
			interval:     "40s"
			legend: {
				alignAsTable: true
				avg:          true
				current:      true
				max:          true
				min:          true
				rightSide:    true
				show:         true
				sort:         "max"
				sortDesc:     true
				total:        false
				values:       true
			}
			lines:         true
			linewidth:     1
			nullPointMode: "null"
			options: alertThreshold: true
			panels: []
			percentage:  false
			pointradius: 2
			points:      false
			renderer:    "flot"
			seriesOverrides: []
			spaceLength: 10
			stack:       true
			steppedLine: false
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "time_series"
					intervalFactor:      1
					query:               """
						SELECT
    $timeSeries as t,
    concat(substring(dictGetString('autnums', 'name', toUInt64(SrcAS)), 1, 25), ' AS', toString(SrcAS)) AS SrcASName,
    sum(Bytes * SamplingRate) * 8 / $interval AS Bps
FROM $table
WHERE
    $timeFilter AND $adhoc
    \(_genericFilter)
    AND SrcAS IN (
    SELECT SrcAS
    FROM $table
    WHERE $timeFilter AND $adhoc
      \(_genericFilter)
    GROUP BY SrcAS
    ORDER BY count(*) DESC
    LIMIT 30)
GROUP BY
    t,
    SrcASName
ORDER BY t, Bps
"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			thresholds: []
			timeRegions: []
			title: "Top 30 Source ASN"
			tooltip: {
				shared:     true
				sort:       2
				value_type: "individual"
			}
			type: "graph"
			xaxis: {
				mode: "time"
				show: true
				values: []
			}
			yaxes: [
				{
					$$hashKey: "object:639"
					format:    "bps"
					logBase:   1
					show:      true
				},
				{
					$$hashKey: "object:640"
					format:    "short"
					logBase:   1
					show:      true
				},
			]
			yaxis: align: false
		},
		{
			aliasColors: {}
			bars:       false
			dashLength: 10
			dashes:     false
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			fieldConfig: {
				defaults: links: []
				overrides: []
			}
			fill:         1
			fillGradient: 0
			gridPos: {
				h: 12
				w: 12
				x: 12
				y: 4
			}
			hiddenSeries: false
			id:           58
			interval:     "40s"
			legend: {
				alignAsTable: true
				avg:          true
				current:      true
				max:          true
				min:          true
				rightSide:    true
				show:         true
				total:        false
				values:       true
			}
			lines:         true
			linewidth:     1
			nullPointMode: "null"
			options: alertThreshold: true
			panels: []
			percentage:  false
			pointradius: 2
			points:      false
			renderer:    "flot"
			seriesOverrides: []
			spaceLength: 10
			stack:       true
			steppedLine: false
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "time_series"
					intervalFactor:      1
					query:               """
						SELECT
    $timeSeries as t,
    concat(substring(dictGetString('autnums', 'name', toUInt64(DstAS)), 1, 25), ' AS', toString(DstAS)) AS DstASName,
    sum(Bytes * SamplingRate) * 8 / $interval AS Bps
FROM $table
WHERE
    $timeFilter AND $adhoc
    \(_genericFilter)
    AND DstAS IN (
    SELECT DstAS
    FROM $table
    WHERE $timeFilter AND $adhoc
      \(_genericFilter)
    GROUP BY DstAS
    ORDER BY count(*) DESC
    LIMIT 30)
GROUP BY
    t,
    DstASName
ORDER BY t, Bps
"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			thresholds: []
			timeRegions: []
			title: "Top 30 Destination ASN"
			tooltip: {
				shared:     true
				sort:       0
				value_type: "individual"
			}
			type: "graph"
			xaxis: {
				mode: "time"
				show: true
				values: []
			}
			yaxes: [
				{
					$$hashKey: "object:639"
					format:    "bps"
					logBase:   1
					show:      true
				},
				{
					$$hashKey: "object:640"
					format:    "short"
					logBase:   1
					show:      true
				},
			]
			yaxis: align: false
		},
		{
			collapsed:  false
			datasource: "NetMeta ClickHouse"
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 16
			}
			id:       20
			interval: "40s"
			panels: []
			targets: [
				{
					datasource: "$datasource"
					refId:      "A"
				},
			]
			title: "AS Relations"
			type:  "row"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 21
				w: 12
				x: 0
				y: 17
			}
			id:       50
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   15
				monochrome:  false
				nodeColor:   "grey"
				nodePadding: 6
				nodeWidth:   23
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  concat(dictGetString('autnums', 'name', toUInt64(SrcAS)), ' AS', toString(SrcAS)) AS SrcASName,
  concat(dictGetString('autnums', 'name', toUInt64(DstAS)), ' AS', toString(DstAS)) AS DstASName,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter AND FlowDirection != 1
\(_genericFilter)
GROUP BY DstASName, SrcASName
ORDER BY Bytes DESC
LIMIT 20

"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Inbound traffic relations (Top 20)"
			transformations: []
			type: "netsage-sankey-panel"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 21
				w: 12
				x: 12
				y: 17
			}
			id:       49
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   15
				monochrome:  false
				nodeColor:   "grey"
				nodePadding: 6
				nodeWidth:   23
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  concat(dictGetString('autnums', 'name', toUInt64(SrcAS)), ' AS', toString(SrcAS)) AS SrcASName,
  concat(dictGetString('autnums', 'name', toUInt64(DstAS)), ' AS', toString(DstAS)) AS DstASName,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter AND FlowDirection != 0
\(_genericFilter)
GROUP BY DstASName, SrcASName
ORDER BY Bytes DESC
LIMIT 20

"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Outbound traffic relations (Top 20)"
			transformations: []
			type: "netsage-sankey-panel"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 21
				w: 12
				x: 0
				y: 38
			}
			id:       52
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   22
				monochrome:  false
				nodeColor:   "grey"
				nodePadding: 9
				nodeWidth:   23
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  concat(dictGetString('autnums', 'name', toUInt64(SrcAS)), ' AS', toString(SrcAS)) AS SrcASName,
  dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), InIf)) AS InIfName,
  concat(dictGetString('autnums', 'name', toUInt64(DstAS)), ' AS', toString(DstAS)) AS DstASName,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter AND FlowDirection != 1
\(_genericFilter)
GROUP BY DstASName, InIfName, SrcASName
ORDER BY Bytes DESC
LIMIT 30

"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Inbound traffic relations via interface  (Top 30)"
			transformations: []
			type: "netsage-sankey-panel"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 21
				w: 12
				x: 12
				y: 38
			}
			id:       51
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   19
				monochrome:  false
				nodeColor:   "#808080"
				nodePadding: 12
				nodeWidth:   23
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  concat(dictGetString('autnums', 'name', toUInt64(SrcAS)), ' AS', toString(SrcAS)) AS SrcASName,
  dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), OutIf)) AS OutIfName,
  concat(dictGetString('autnums', 'name', toUInt64(DstAS)), ' AS', toString(DstAS)) AS DstASName,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter AND FlowDirection != 0
\(_genericFilter)
GROUP BY DstASName, SrcASName, OutIfName
ORDER BY Bytes DESC
LIMIT 40

"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Outbound traffic relations via interface (Top 30)"
			transformations: []
			type: "netsage-sankey-panel"
		},
		{
			collapsed:  false
			datasource: "NetMeta ClickHouse"
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 59
			}
			id:       18
			interval: "40s"
			panels: []
			targets: [
				{
					datasource: "$datasource"
					refId:      "A"
				},
			]
			title: "Top Flows"
			type:  "row"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 22
				w: 12
				x: 0
				y: 60
			}
			id:       7
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   9
				monochrome:  false
				nodeColor:   "grey"
				nodePadding: 6
				nodeWidth:   28
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  SrcAddr,
  DstAddr,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter
\(_genericFilter)
GROUP BY SrcAddr, DstAddr
ORDER BY Bytes DESC
LIMIT 30
"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Top 30 Flows (per IP)"
			transformations: []
			type: "netsage-sankey-panel"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 22
				w: 12
				x: 12
				y: 60
			}
			id:       10
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   7
				monochrome:  false
				nodeColor:   "grey"
				nodePadding: 11
				nodeWidth:   28
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  concat(IPv6NumToString(SrcAddr), ' ', dictGetString('IPProtocols', 'Name', toUInt64(Proto)),toString(SrcPort)) as Src,
  concat(IPv6NumToString(DstAddr), ' ', dictGetString('IPProtocols', 'Name', toUInt64(Proto)),toString(DstPort)) as Dst,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter
\(_genericFilter)
GROUP BY Src, Dst
ORDER BY Bytes DESC
LIMIT 30

"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Top 30 Flows (per IP+Port)"
			transformations: []
			type: "netsage-sankey-panel"
		},
		{
			collapsed: false
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			gridPos: {
				h: 1
				w: 24
				x: 0
				y: 82
			}
			id: 56
			panels: []
			targets: [
				{
					datasource: "$datasource"
					refId:      "A"
				},
			]
			title: "Flows per ASN"
			type:  "row"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 22
				w: 12
				x: 0
				y: 83
			}
			id:       53
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   7
				monochrome:  false
				nodeColor:   "grey"
				nodePadding: 11
				nodeWidth:   28
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  concat(dictGetString('autnums', 'name', toUInt64(SrcAS)), ' AS', toString(SrcAS)) AS SrcASName,
  concat(IPv6NumToString(DstAddr), ' ', dictGetString('IPProtocols', 'Name', toUInt64(Proto)),toString(DstPort)) as Dst,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter AND FlowDirection != 1
\(_genericFilter)
GROUP BY SrcASName, Dst
ORDER BY Bytes DESC
LIMIT 30

"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Top 30 ASN per service (inbound)"
			transformations: []
			type: "netsage-sankey-panel"
		},
		{
			datasource: {
				type: "datasource"
				uid:  "grafana"
			}
			description: ""
			gridPos: {
				h: 22
				w: 12
				x: 12
				y: 83
			}
			id:       54
			interval: "40s"
			options: {
				color:       "blue"
				iteration:   7
				monochrome:  false
				nodeColor:   "grey"
				nodePadding: 11
				nodeWidth:   28
			}
			panels: []
			pluginVersion: "8.3.2"
			targets: [
				{
					datasource:          "$datasource"
					dateColDataType:     ""
					dateLoading:         false
					dateTimeColDataType: "TimeReceived"
					dateTimeType:        "DATETIME"
					datetimeLoading:     false
					extrapolate:         true
					format:              "table"
					intervalFactor:      1
					query:               """
						SELECT
  concat(dictGetString('autnums', 'name', toUInt64(SrcAS)), ' AS', toString(SrcAS)) AS SrcASName,
  concat(IPv6NumToString(DstAddr), ' ', dictGetString('IPProtocols', 'Name', toUInt64(Proto)),toString(DstPort)) as Dst,
  sum(Bytes * SamplingRate) / 1024 as Bytes
FROM $table
WHERE $timeFilter AND FlowDirection != 0
\(_genericFilter)
GROUP BY SrcASName, Dst
ORDER BY Bytes DESC
LIMIT 30

"""
					refId:               "A"
					round:               "0s"
					skip_comments:       true
					table:               "flows_raw"
					tableLoading:        false
				},
			]
			title: "Top 30 ASN per service (outbound)"
			transformations: []
			type: "netsage-sankey-panel"
		},
	]
	refresh:       false
	schemaVersion: 37
	style:         "dark"
	tags: []
	templating: list: [{...}, {
		hide: 2
		name: "adhoc_query_filter"
		query: """
							SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table
			"""
		skipUrlSync: false
		type:        "constant"
	},
		{
			current: {
				selected: false
				text:     "All"
				value:    "$__all"
			}
			datasource: uid: "NetMeta ClickHouse"
			hide:       0
			includeAll: true
			label:      "Source"
			multi:      false
			name:       "sampler"
			options: []
			query: """
								SELECT DISTINCT IPv6NumToString(SamplerAddress) FROM flows_raw WHERE $timeFilterByColumn(TimeReceived)
				"""
			refresh:        2
			regex:          ""
			skipUrlSync:    false
			sort:           0
			tagValuesQuery: ""
			tagsQuery:      ""
			type:           "query"
			useTags:        false
		},
		{
			current: {
				selected: false
				text:     "All"
				value:    "$__all"
			}
			datasource: uid: "NetMeta ClickHouse"
			hide:       0
			includeAll: true
			label:      "Interface"
			multi:      false
			name:       "interface"
			options: []
			query: """
				SELECT toString(InIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), InIf)) || ')' AS __text, InIf AS __value FROM (SELECT DISTINCT SamplerAddress, InIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))
				UNION ALL
				SELECT toString(OutIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), OutIf)) || ')' AS __text, OutIf AS __value FROM (SELECT DISTINCT SamplerAddress, OutIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))
				"""
			refresh:        2
			regex:          ""
			skipUrlSync:    false
			sort:           0
			tagValuesQuery: ""
			tagsQuery:      ""
			type:           "query"
			useTags:        false
		},
		{
			datasource: uid: "NetMeta ClickHouse"
			filters: []
			hide:        0
			label:       "Custom filters"
			name:        "adhoc_query"
			skipUrlSync: false
			type:        "adhoc"
		},
		{
			current: {
				selected: false
				text:     ""
				value:    ""
			}
			hide:  0
			label: "Src IPv6"
			name:  "srcIP"
			options: [
				{
					selected: true
					text:     ""
					value:    ""
				},
			]
			query:       ""
			skipUrlSync: false
			type:        "textbox"
		},
		{
			current: {
				selected: false
				text:     ""
				value:    ""
			}
			hide:  0
			label: "Dst IPv6"
			name:  "dstIP"
			options: [
				{
					selected: true
					text:     ""
					value:    ""
				},
			]
			query:       ""
			skipUrlSync: false
			type:        "textbox"
		},
		{
			current: {
				selected: false
				text:     ""
				value:    ""
			}
			hide:  0
			label: "Src/Dst IPv6"
			name:  "hostIP"
			options: [
				{
					selected: true
					text:     ""
					value:    ""
				},
			]
			query:       ""
			skipUrlSync: false
			type:        "textbox"
		},
		{
			current: {
				selected: true
				text:     ""
				value:    ""
			}
			hide:  0
			label: "Next Hop IPv6"
			name:  "nextHop"
			options: [
				{
					selected: true
					text:     ""
					value:    ""
				},
			]
			query:       ""
			skipUrlSync: false
			type:        "textbox"
		},
		{
			current: {
				selected: true
				text:     ""
				value:    ""
			}
			hide:  0
			label: "Custom SQL"
			name:  "extra"
			options: [
				{
					selected: true
					text:     ""
					value:    ""
				},
			]
			query:       ""
			skipUrlSync: false
			type:        "textbox"
		},
	]
	time: {
		from: "now-2h"
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
	title:    "Traffic Relations"
	uid:      "5pH2j5ank"
}
