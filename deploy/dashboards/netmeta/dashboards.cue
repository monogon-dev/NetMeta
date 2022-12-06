package netmeta

#Config: {
	// Minimum interval for all panels
	interval: string | null

	// Maximum packet size for heatmaps (filter out spurious oversized packet from loopback interfaces)
	maxPacketSize: uint | *1500

	// The config for the FastNetMon integration
	fastNetMon?: {
		dataSource: string | *null
		...
	}
}

_genericFilterWithoutHost: """
	$conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)
	$conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)
	$conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)
	$conditionalTest(AND DstAS = '$dstAS', $dstAS)
	$conditionalTest(AND SrcAS = '$srcAS', $srcAS)
	$conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)
	$conditionalTest(AND ((toString(SamplerAddress) || '-' || toString(InIf)) = $interface OR (toString(SamplerAddress) || '-' || toString(OutIf)) = $interface), $interface)
	$conditionalTest(AND ($extra), $extra)
	"""

_genericFilter: """
\(_genericFilterWithoutHost)
$conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)
"""

#Panel: {
	interval: #Config.interval
	panels: [...#Panel]
	...
}

dashboards: [T=string]: {
	title: T
	panels: [...#Panel]
	annotations: list: [{
		builtIn:    1
		datasource: "-- Grafana --"
		enable:     true
		hide:       true
		iconColor:  "rgba(0, 211, 255, 1)"
		name:       "Annotations & Alerts"
		target: {
			limit:    100
			matchAny: false
			tags: []
			type: "dashboard"
		}
		type: "dashboard"
	},
		if #Config.fastNetMon != _|_ {
			{
				datasource: {
					type: "influxdb"
					uid:  "${datasource_fnm}"
				}
				enable:     true
				iconColor:  "red"
				name:       "FastNetMon Attacks"
				query:      "select title, tags, text from events where $timeFilter"
				tagsColumn: "tags"
				target: {
					limit:    100
					matchAny: false
					tags: []
					type: "dashboard"
				}
				textColumn: "text"
			}
		},
	]
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
	},
		if #Config.fastNetMon != _|_ {
			{
				current: {
					selected: false
					text:     #Config.fastNetMon.name
					value:    #Config.fastNetMon.name
				}
				hide:       0
				includeAll: false
				label:      "Datasource"
				multi:      false
				name:       "datasource_fnm"
				query:      "influxdb"
				regex:      ""
				type:       "datasource"
			}
		},
		{
			hide:        2
			name:        "adhoc_query_filter"
			query:       "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
			skipUrlSync: false
			type:        "constant"
		},
		{
			current: {
				selected: false
				text:     "All"
				value:    "$__all"
			}
			datasource: "$datasource"
			hide:       0
			includeAll: true
			label:      "Source"
			multi:      false
			name:       "sampler"
			options: []
			query:          "SELECT DISTINCT IPv6NumToString(SamplerAddress) FROM flows_raw WHERE $timeFilterByColumn(TimeReceived)"
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
			datasource: "$datasource"
			hide:       0
			includeAll: true
			label:      "Interface"
			multi:      false
			name:       "interface"
			options: []
			query: """
				SELECT InterfaceToString(SamplerAddress, InIf) AS __text,
								(toString(SamplerAddress) || '-' || toString(InIf)) AS __value
				FROM (SELECT DISTINCT SamplerAddress, InIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))
				UNION ALL
				SELECT InterfaceToString(SamplerAddress, OutIf) AS __text,
								(toString(SamplerAddress) || '-' || toString(OutIf)) AS __value
				FROM (SELECT DISTINCT SamplerAddress, OutIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))
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
			datasource: "$datasource"
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
					selected: false
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
					selected: false
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
				selected: false
				text:     ""
				value:    ""
			}
			hide:  0
			label: "Src AS"
			name:  "srcAS"
			options: [
				{
					selected: false
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
			label: "Dst AS"
			name:  "dstAS"
			options: [
				{
					selected: false
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

}
