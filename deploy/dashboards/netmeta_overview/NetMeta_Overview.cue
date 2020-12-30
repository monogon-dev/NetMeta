package netmeta_overview

#Config: {
	// Minimum interval for all panels
	interval: string | null
}

_genericFilterWithoutHost: """
	$conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)
	$conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)
	$conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)
	$conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)
	$conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)
	$conditionalTest(AND ($extra), $extra)
	"""

_genericFilter: """
\(_genericFilterWithoutHost)
$conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)
"""

panels: [
	...{
		interval: #Config.interval
	},
]

annotations: list: [{
	builtIn:    1
	datasource: "-- Grafana --"
	enable:     true
	hide:       true
	iconColor:  "rgba(0, 211, 255, 1)"
	name:       "Annotations & Alerts"
	type:       "dashboard"
}]
editable:     true
gnetId:       null
graphTooltip: 1
links: []
panels: [{
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: align: null
			mappings: []
			thresholds: {
				mode: "absolute"
				steps: [{
					color: "green"
					value: null
				}]
			}
			unit: "short"
		}
		overrides: []
	}
	gridPos: {
		h: 3
		w: 5
		x: 0
		y: 0
	}
	id: 37
	options: {
		colorMode:   "value"
		graphMode:   "area"
		justifyMode: "auto"
		orientation: "auto"
		reduceOptions: {
			calcs: [
				"mean",
			]
			fields: ""
			values: true
		}
		textMode: "auto"
	}
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     "Date"
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query:               """
			SELECT count()
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Filtered Flows "
	type:      "stat"
}, {
	datasource:  "NetMeta ClickHouse"
	description: "Does not include Kafka usage (which is capped by `goflowTopicRetention` config)."
	fieldConfig: {
		defaults: {
			custom: align: null
			mappings: []
			thresholds: {
				mode: "absolute"
				steps: [{
					color: "purple"
					value: null
				}]
			}
			unit: "bytes"
		}
		overrides: []
	}
	gridPos: {
		h: 3
		w: 5
		x: 5
		y: 0
	}
	id: 38
	options: {
		colorMode:   "value"
		graphMode:   "area"
		justifyMode: "auto"
		orientation: "auto"
		reduceOptions: {
			calcs: [
				"mean",
			]
			fields: ""
			values: true
		}
		textMode: "auto"
	}
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "FlowReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query:               "select sum(bytes_on_disk) from system.parts"
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Disk Usage"
	type:      "stat"
}, {
	datasource: "-- Grafana --"
	fieldConfig: {
		defaults: custom: {}
		overrides: []
	}
	gridPos: {
		h: 3
		w: 5
		x: 19
		y: 0
	}
	id: 44
	options: {
		content: "This dashboard is provisioned automatically and will be overwritten when you update NetMeta. If you want to make persistent changes, please create a copy."
		mode:    "markdown"
	}
	pluginVersion: "7.3.6"
	targets: [{
		queryType: "randomWalk"
		refId:     "A"
	}]
	timeFrom:  null
	timeShift: null
	title:     "This is a preprovisioned dashboard"
	type:      "text"
}, {
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: align: null
			mappings: []
			thresholds: {
				mode: "absolute"
				steps: [{
					color: "purple"
					value: null
				}]
			}
			unit: "short"
		}
		overrides: []
	}
	gridPos: {
		h: 3
		w: 5
		x: 0
		y: 3
	}
	id: 24
	options: {
		colorMode:   "value"
		graphMode:   "area"
		justifyMode: "auto"
		orientation: "auto"
		reduceOptions: {
			calcs: [
				"mean",
			]
			fields: ""
			values: true
		}
		textMode: "auto"
	}
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "FlowReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query: """
			SELECT count()
			FROM $table
			"""
		refId:        "A"
		round:        "0s"
		table:        "flows_raw"
		tableLoading: false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Total Flows Stored"
	type:      "stat"
}, {
	datasource:  "NetMeta ClickHouse"
	description: ""
	fieldConfig: {
		defaults: {
			custom: align: null
			mappings: []
			thresholds: {
				mode: "absolute"
				steps: [{
					color: "purple"
					value: null
				}]
			}
			unit: "dtdurations"
		}
		overrides: []
	}
	gridPos: {
		h: 3
		w: 5
		x: 5
		y: 3
	}
	id: 39
	options: {
		colorMode:   "value"
		graphMode:   "area"
		justifyMode: "auto"
		orientation: "auto"
		reduceOptions: {
			calcs: [
				"mean",
			]
			fields: ""
			values: true
		}
		textMode: "auto"
	}
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "FlowReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query:               "select (toUnixTimestamp(now()) - TimeReceived) from flows_raw order by TimeReceived limit 1"
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Effective Retention"
	type:      "stat"
}, {
	datasource: "-- Grafana --"
	fieldConfig: {
		defaults: custom: {}
		overrides: []
	}
	gridPos: {
		h: 3
		w: 5
		x: 19
		y: 3
	}
	id: 43
	options: {
		content: """
			For questions, bug reports or feature requests please refer to https://github.com/leoluk/NetMeta or send a mail to netmeta@leoluk.de

			Contributions are very welcome!
			"""
		mode: "markdown"
	}
	pluginVersion: "7.3.6"
	targets: [{
		queryType: "randomWalk"
		refId:     "A"
	}]
	timeFrom:  null
	timeShift: null
	title:     "Contact and Support"
	type:      "text"
}, {
	collapsed:  false
	datasource: "NetMeta ClickHouse"
	gridPos: {
		h: 1
		w: 24
		x: 0
		y: 6
	}
	id: 16
	panels: []
	title: "Traffic Statistics"
	type:  "row"
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 7
	}
	hiddenSeries: false
	id:           2
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:86"
		alias:     "out"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    sum(Packets * SamplingRate) / $interval AS Packets,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Packets "
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	transformations: []
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:783"
		format:    "pps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:784"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 7
	}
	hiddenSeries: false
	id:           4
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:141"
		alias:     "out"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Throughput"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 19
	}
	hiddenSeries: false
	id:           8
	legend: {
		alignAsTable: false
		avg:          false
		current:      false
		hideEmpty:    false
		hideZero:     false
		max:          false
		min:          false
		rightSide:    false
		show:         true
		sort:         "current"
		sortDesc:     true
		total:        false
		values:       false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:196"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) || ' (' || toString(Proto) || ')' AS Proto,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, Proto, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "IP Proto"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 19
	}
	hiddenSeries: false
	id:           28
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:196"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    dictGetString('EtherTypes', 'Name', toUInt64(EType)) || ' (' || hex(EType) || ')' AS EType,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, EType, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Ethernet Type"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 31
	}
	hiddenSeries: false
	id:           11
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: []
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    count(*) / $interval AS Flows,
			    SamplerAddress
			FROM $table
			WHERE
			    $timeFilter
			    \(_genericFilter)
			GROUP BY
			    t, SamplerAddress
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Raw Flows/s Per Host"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "pps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 31
	}
	hiddenSeries: false
	id:           12
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: []
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    NextHop,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps
			FROM $table
			WHERE $timeFilter AND NextHop != toIPv6('::')
			\(_genericFilter)
			GROUP BY t, NextHop
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Traffic per Next Hop"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 43
	}
	hiddenSeries: false
	id:           13
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:257"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    SamplerAddress,
			    toString(InIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), InIf)) || ')' AS InIf,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, SamplerAddress, InIf, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Traffic per Ingress Interface"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 43
	}
	hiddenSeries: false
	id:           14
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	options: alertThreshold: true
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:257"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    SamplerAddress,
			    toString(OutIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), OutIf)) || ')' AS OutIf,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, SamplerAddress, OutIf, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Traffic per Egress Interface"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	collapsed:  false
	datasource: "NetMeta ClickHouse"
	gridPos: {
		h: 1
		w: 24
		x: 0
		y: 55
	}
	id: 20
	panels: []
	title: "Origin AS Stats"
	type:  "row"
}, {
	datasource:  "NetMeta ClickHouse"
	description: ""
	fieldConfig: {
		defaults: {
			custom: {
				align:       null
				displayMode: "auto"
				filterable:  false
			}
			mappings: []
			thresholds: {
				mode: "percentage"
				steps: [{
					color: "green"
					value: null
				}, {
					color: "red"
					value: 80
				}]
			}
		}
		overrides: [{
			matcher: {
				id:      "byName"
				options: "Bytes"
			}
			properties: [{
				id:    "custom.displayMode"
				value: "gradient-gauge"
			}, {
				id:    "unit"
				value: "kbytes"
			}, {
				id: "max"
			}]
		}]
	}
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 56
	}
	id: 5
	options: showHeader: true
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query:               """
			SELECT
			  SrcAS,
			  sum(Bytes * SamplingRate) / 1024 as Bytes
			FROM $table
			WHERE $timeFilter AND FlowDirection = 0
			\(_genericFilter)
			GROUP BY SrcAS
			ORDER BY Bytes DESC
			LIMIT 100

			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Top Source ASNs"
	transformations: []
	type: "table"
}, {
	datasource:  "NetMeta ClickHouse"
	description: ""
	fieldConfig: {
		defaults: {
			custom: {
				align:       null
				displayMode: "auto"
				filterable:  false
			}
			mappings: []
			thresholds: {
				mode: "percentage"
				steps: [{
					color: "green"
					value: null
				}, {
					color: "red"
					value: 80
				}]
			}
		}
		overrides: [{
			matcher: {
				id:      "byName"
				options: "Bytes"
			}
			properties: [{
				id:    "custom.displayMode"
				value: "gradient-gauge"
			}, {
				id:    "unit"
				value: "kbytes"
			}, {
				id: "max"
			}]
		}]
	}
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 56
	}
	id: 6
	options: showHeader: true
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query:               """
			SELECT
			  DstAS,
			  sum(Bytes * SamplingRate) / 1024 as Bytes
			FROM $table
			WHERE $timeFilter AND FlowDirection = 1
			\(_genericFilter)
			GROUP BY DstAS
			ORDER BY Bytes DESC
			LIMIT 101
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Top Destination ASNs"
	transformations: []
	type: "table"
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 68
	}
	hiddenSeries: false
	id:           25
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: []
	spaceLength: 10
	stack:       true
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    SrcAS,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps
			FROM $table
			WHERE
			    $timeFilter AND FlowDirection = 0
			    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)
			    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)
			    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)
			    $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)
			    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)
			    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)
			    AND SrcAS IN (
			    SELECT SrcAS
			    FROM $table
			    WHERE $timeFilter AND FlowDirection = 0 AND $adhoc
			      \(_genericFilter)
			    GROUP BY SrcAS
			    ORDER BY count(*) DESC
			    LIMIT 10)
			    $conditionalTest(AND ($extra), $extra)
			GROUP BY
			    t,
			    SrcAS
			ORDER BY t, Bps
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Top 10 Source ASN"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 68
	}
	hiddenSeries: false
	id:           30
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: []
	spaceLength: 10
	stack:       true
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    DstAS,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps
			FROM $table
			WHERE
			    $timeFilter AND FlowDirection = 1
			    \(_genericFilter)
			    AND DstAS IN (
			    SELECT DstAS
			    FROM $table
			    WHERE $timeFilter AND FlowDirection = 1 AND $adhoc
			      \(_genericFilter)
			    GROUP BY DstAS
			    ORDER BY count(*) DESC
			    LIMIT 10)
			GROUP BY
			    t,
			    DstAS
			ORDER BY t, Bps
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Top 10 Destination ASN"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	collapsed:  false
	datasource: "NetMeta ClickHouse"
	gridPos: {
		h: 1
		w: 24
		x: 0
		y: 80
	}
	id: 27
	panels: []
	title: "Traffic Details (expensive)"
	type:  "row"
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 81
	}
	hiddenSeries: false
	id:           31
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:196"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,

			    arrayStringConcat(
			      arrayMap(
			        x -> dictGetString('TCPFlags', 'Name', toUInt64(x)), bitmaskToArray(TCPFlags))
			      , '-')
			    || ' (' || toString(TCPFlags) || ')' AS TCPFlags,

			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter AND Proto = 6
			\(_genericFilter)
			GROUP BY t, TCPFlags, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "TCP Flags"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 81
	}
	hiddenSeries: false
	id:           32
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:196"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    VlanId,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, VlanId, FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "VLAN ID"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 93
	}
	hiddenSeries: false
	id:           29
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:251"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    SrcPort,
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS Proto,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE
			    $timeFilter
			    \(_genericFilter)
			    AND SrcPort IN (
			    SELECT SrcPort
			    FROM $table
			    WHERE $timeFilter AND $adhoc
			      \(_genericFilter)
			    GROUP BY SrcPort
			    ORDER BY count(*) DESC
			    LIMIT 10)
			GROUP BY
			    t,
			    Proto,
			    SrcPort,
			    FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Top 10 Source Ports"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	transformations: []
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 93
	}
	hiddenSeries: false
	id:           9
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:251"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    DstPort,
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS Proto,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE
			    $timeFilter
			    \(_genericFilter)
			    AND DstPort IN (
			    SELECT DstPort
			    FROM $table
			    WHERE $timeFilter AND $adhoc
			    \(_genericFilter)
			    GROUP BY DstPort
			    ORDER BY count(*) DESC
			    LIMIT 10)
			GROUP BY
			    t,
			    Proto,
			    DstPort,
			    FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Top 10 Destination Ports"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 0
		y: 105
	}
	hiddenSeries: false
	id:           33
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:251"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    SrcAddr,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE
			    $timeFilter
			    \(_genericFilter)
			    AND SrcAddr IN (
			    SELECT SrcAddr
			    FROM $table
			    WHERE $timeFilter AND $adhoc
			      \(_genericFilter)
			    GROUP BY SrcAddr
			    ORDER BY sum(Bytes) DESC
			    LIMIT 10)
			GROUP BY
			    t,
			    SrcAddr,
			    FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Top 10 Source IPs"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	transformations: []
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	aliasColors: {}
	bars:       false
	dashLength: 10
	dashes:     false
	datasource: "NetMeta ClickHouse"
	fieldConfig: {
		defaults: {
			custom: {}
			links: []
		}
		overrides: []
	}
	fill:         1
	fillGradient: 0
	gridPos: {
		h: 12
		w: 12
		x: 12
		y: 105
	}
	hiddenSeries: false
	id:           34
	legend: {
		avg:     false
		current: false
		max:     false
		min:     false
		show:    true
		total:   false
		values:  false
	}
	lines:         true
	linewidth:     1
	nullPointMode: "null"
	percentage:    false
	pluginVersion: "7.3.6"
	pointradius:   2
	points:        false
	renderer:      "flot"
	seriesOverrides: [{
		$$hashKey: "object:251"
		alias:     "/, out/"
		transform: "negative-Y"
	}]
	spaceLength: 10
	stack:       false
	steppedLine: false
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "time_series"
		intervalFactor:      1
		query:               """
			SELECT
			    $timeSeries as t,
			    DstAddr,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirection
			FROM $table
			WHERE
			    $timeFilter
			    \(_genericFilter)
			    AND DstAddr IN (
			    SELECT DstAddr
			    FROM $table
			    WHERE $timeFilter AND $adhoc
			      \(_genericFilter)
			    GROUP BY DstAddr
			    ORDER BY sum(Bytes) DESC
			    LIMIT 10)
			GROUP BY
			    t,
			    DstAddr,
			    FlowDirection
			ORDER BY t
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	thresholds: []
	timeFrom: null
	timeRegions: []
	timeShift: null
	title:     "Top 10 Destination IPs"
	tooltip: {
		shared:     true
		sort:       0
		value_type: "individual"
	}
	transformations: []
	type: "graph"
	xaxis: {
		buckets: null
		mode:    "time"
		name:    null
		show:    true
		values: []
	}
	yaxes: [{
		$$hashKey: "object:639"
		format:    "bps"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}, {
		$$hashKey: "object:640"
		format:    "short"
		label:     null
		logBase:   1
		max:       null
		min:       null
		show:      true
	}]
	yaxis: {
		align:      false
		alignLevel: null
	}
}, {
	collapsed:  false
	datasource: "NetMeta ClickHouse"
	gridPos: {
		h: 1
		w: 24
		x: 0
		y: 117
	}
	id: 18
	panels: []
	title: "Top Hosts (expensive)"
	type:  "row"
}, {
	datasource:  "NetMeta ClickHouse"
	description: ""
	fieldConfig: {
		defaults: {
			custom: {
				align:       null
				displayMode: "auto"
				filterable:  false
			}
			mappings: []
			thresholds: {
				mode: "percentage"
				steps: [{
					color: "green"
					value: null
				}, {
					color: "red"
					value: 80
				}]
			}
		}
		overrides: [{
			matcher: {
				id:      "byName"
				options: "Bytes"
			}
			properties: [{
				id:    "custom.displayMode"
				value: "gradient-gauge"
			}, {
				id:    "unit"
				value: "kbytes"
			}, {
				id: "max"
			}, {
				id:    "custom.width"
				value: null
			}]
		}]
	}
	gridPos: {
		h: 14
		w: 12
		x: 0
		y: 118
	}
	id: 7
	options: showHeader: true
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query:               """
			SELECT
			  SamplerAddress,
			  SrcAddr,
			  sum(Bytes * SamplingRate) / 1024 as Bytes
			FROM $table
			WHERE $timeFilter
			\(_genericFilterWithoutHost)
			$conditionalTest(AND DstAddr = toIPv6('$hostIP'), $hostIP)
			GROUP BY SamplerAddress, SrcAddr
			ORDER BY Bytes DESC
			LIMIT 20
			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Top Source IPs"
	transformations: []
	type: "table"
}, {
	datasource:  "NetMeta ClickHouse"
	description: ""
	fieldConfig: {
		defaults: {
			custom: {
				align:       null
				displayMode: "auto"
				filterable:  false
			}
			mappings: []
			thresholds: {
				mode: "percentage"
				steps: [{
					color: "green"
					value: null
				}, {
					color: "red"
					value: 80
				}]
			}
		}
		overrides: [{
			matcher: {
				id:      "byName"
				options: "Bytes"
			}
			properties: [{
				id:    "custom.displayMode"
				value: "gradient-gauge"
			}, {
				id:    "unit"
				value: "kbytes"
			}, {
				id: "max"
			}]
		}]
	}
	gridPos: {
		h: 14
		w: 12
		x: 12
		y: 118
	}
	id: 3
	options: showHeader: true
	pluginVersion: "7.3.6"
	targets: [{
		database:            "default"
		dateColDataType:     ""
		dateLoading:         false
		dateTimeColDataType: "TimeReceived"
		dateTimeType:        "DATETIME"
		datetimeLoading:     false
		format:              "table"
		intervalFactor:      1
		query:               """
			SELECT
			  SamplerAddress,
			  DstAddr,
			  sum(Bytes * SamplingRate) / 1024 as Bytes
			FROM $table
			WHERE $timeFilter
			\(_genericFilterWithoutHost)
			$conditionalTest(AND SrcAddr = toIPv6('$hostIP'), $hostIP)
			GROUP BY SamplerAddress, DstAddr
			ORDER BY Bytes DESC
			LIMIT 20

			"""
		refId:               "A"
		round:               "0s"
		table:               "flows_raw"
		tableLoading:        false
	}]
	timeFrom:  null
	timeShift: null
	title:     "Top Destination IPs"
	transformations: []
	type: "table"
}, {
	collapsed:  true
	datasource: "NetMeta ClickHouse"
	gridPos: {
		h: 1
		w: 24
		x: 0
		y: 132
	}
	id: 36
	panels: [{
		datasource:  "NetMeta ClickHouse"
		description: ""
		fieldConfig: {
			defaults: {
				custom: {
					align:       null
					displayMode: "auto"
				}
				mappings: []
				thresholds: {
					mode: "percentage"
					steps: [{
						color: "green"
						value: null
					}, {
						color: "red"
						value: 80
					}]
				}
			}
			overrides: [{
				matcher: {
					id:      "byName"
					options: "Bytes"
				}
				properties: [{
					id:    "custom.displayMode"
					value: "gradient-gauge"
				}, {
					id:    "unit"
					value: "kbytes"
				}, {
					id: "max"
				}]
			}]
		}
		gridPos: {
			h: 12
			w: 24
			x: 0
			y: 130
		}
		id: 10
		options: showHeader: true
		pluginVersion: "7.0.0"
		targets: [{
			database:            "default"
			dateColDataType:     ""
			dateLoading:         false
			dateTimeColDataType: "TimeReceived"
			dateTimeType:        "DATETIME"
			datetimeLoading:     false
			format:              "table"
			intervalFactor:      1
			query:               """
				SELECT
				  SamplerAddress,
				  SrcAddr,
				  DstAddr,
				  SrcPort,
				  DstPort,
				  dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS Proto,
				  sum(Bytes * SamplingRate) / 1024 as Bytes
				FROM $table
				WHERE $timeFilter
				\(_genericFilter)
				GROUP BY SamplerAddress, SrcAddr, DstAddr, SrcPort, DstPort, Proto
				ORDER BY Bytes DESC
				LIMIT 20

				"""
			refId:               "A"
			round:               "0s"
			table:               "flows_raw"
			tableLoading:        false
		}]
		timeFrom:  null
		timeShift: null
		title:     "Top Flows"
		transformations: []
		type: "table"
	}]
	title: "Top Flows (very expensive)"
	type:  "row"
}]
refresh:       false
schemaVersion: 26
style:         "dark"
tags: []
templating: list: [{
	current: {
		text:  "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
		value: "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
	}
	error: null
	hide:  2
	label: null
	name:  "adhoc_query_filter"
	options: [{
		text:  "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
		value: "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
	}]
	query:       "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
	skipUrlSync: false
	type:        "constant"
}, {
	allValue: null
	current: {
		selected: false
		text:     "All"
		value:    "$__all"
	}
	datasource: "NetMeta ClickHouse"
	definition: "SELECT DISTINCT IPv6NumToString(SamplerAddress) FROM flows_raw WHERE $timeFilterByColumn(TimeReceived)"
	error:      null
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
	tags: []
	tagsQuery: ""
	type:      "query"
	useTags:   false
}, {
	allValue: null
	current: {
		selected: false
		text:     "All"
		value:    "$__all"
	}
	datasource: "NetMeta ClickHouse"
	definition: """
		SELECT toString(InIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), InIf)) || ')' AS __text, InIf AS __value FROM (SELECT DISTINCT SamplerAddress, InIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))
		UNION ALL
		SELECT toString(OutIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), OutIf)) || ')' AS __text, OutIf AS __value FROM (SELECT DISTINCT SamplerAddress, OutIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))
		"""
	error:      null
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
	tags: []
	tagsQuery: ""
	type:      "query"
	useTags:   false
}, {
	datasource: "NetMeta ClickHouse"
	error:      null
	filters: []
	hide:        0
	label:       "Custom filters"
	name:        "adhoc_query"
	skipUrlSync: false
	type:        "adhoc"
}, {
	current: {
		selected: false
		text:     ""
		value:    ""
	}
	error: null
	hide:  0
	label: "Src IPv6"
	name:  "srcIP"
	options: [{
		selected: false
		text:     ""
		value:    ""
	}]
	query:       ""
	skipUrlSync: false
	type:        "textbox"
}, {
	current: {
		selected: false
		text:     ""
		value:    ""
	}
	error: null
	hide:  0
	label: "Dst IPv6"
	name:  "dstIP"
	options: [{
		selected: false
		text:     ""
		value:    ""
	}]
	query:       ""
	skipUrlSync: false
	type:        "textbox"
}, {
	current: {
		selected: false
		text:     ""
		value:    ""
	}
	error: null
	hide:  0
	label: "Src/Dst IPv6"
	name:  "hostIP"
	options: [{
		selected: true
		text:     ""
		value:    ""
	}]
	query:       ""
	skipUrlSync: false
	type:        "textbox"
}, {
	current: {
		selected: true
		text:     ""
		value:    ""
	}
	error: null
	hide:  0
	label: "Next Hop IPv6"
	name:  "nextHop"
	options: [{
		selected: true
		text:     ""
		value:    ""
	}]
	query:       ""
	skipUrlSync: false
	type:        "textbox"
}, {
	current: {
		selected: true
		text:     ""
		value:    ""
	}
	error: null
	hide:  0
	label: "Custom SQL"
	name:  "extra"
	options: [{
		selected: true
		text:     ""
		value:    ""
	}]
	query:       ""
	skipUrlSync: false
	type:        "textbox"
}]
time: {
	from: "now-3h"
	to:   "now"
}
timepicker: refresh_intervals: ["10s", "30s", "1m", "5m", "15m", "30m", "1h", "2h", "1d"]
timezone: ""
title:    "NetMeta Overview"
uid:      "9Dw5dGzGk"
