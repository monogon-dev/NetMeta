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

_filters:
	#"""
		AND $__conditionalAll((SamplerAddress = toIPv6('$sampler')), $sampler)
		AND $__conditionalAll((SrcAddr = toIPv6('$srcIP')), $srcIP)
		AND $__conditionalAll((DstAddr = toIPv6('$dstIP')), $dstIP)
		AND $__conditionalAll((isIPAddressInRange(toString(SrcAddr), '$srcNet')), $srcNet)
		AND $__conditionalAll((isIPAddressInRange(toString(DstAddr), '$dstNet')), $dstNet)
		AND $__conditionalAll((isIPAddressInRange(toString(SrcAddr), '$hostNet') OR isIPAddressInRange(toString(DstAddr), '$hostNet')), $hostNet)
		AND $__conditionalAll((DstAS = '$dstAS'), $dstAS)
		AND $__conditionalAll((SrcAS = '$srcAS'), $srcAS)
		AND $__conditionalAll((NextHop = toIPv6('$nextHop')), $nextHop)
		AND $__conditionalAll(((toString(SamplerAddress) || '-' || toString(InIf)) = '$interface' OR (toString(SamplerAddress) || '-' || toString(OutIf)) = '$interface'), '$interface')
		AND $__conditionalAll(($extra), $extra)
		"""#

_filtersWithHost:
	#"""
\#(_filters)
AND $__conditionalAll((SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)
"""#

_disclamerPanels: [{
	title: "This is a preprovisioned dashboard"
	type:  "text"
	gridPos: {h: 3, w: 5, x: 19, y: 0}
	options: content: #"""
		This dashboard is provisioned automatically and will be overwritten when you update NetMeta.
		If you want to make persistent changes, please create a copy.
		"""#
}, {
	title: "Contact and Support"
	type:  "text"
	gridPos: {h: 3, w: 5, x: 19, y: 3}
	options: content: #"""
		For questions, bug reports or feature requests please refer to https://github.com/monogon-dev/NetMeta or send a mail to netmeta@leoluk.de

		Contributions are very welcome!
		"""#
}]

_infoPanelQueries: {
	"Filtered Flows":
		#"""
			SELECT count()
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			"""#
	"Disk Usage":
		#"""
			SELECT sum(bytes_on_disk) FROM system.parts
			"""#
	"Total Flows Stored":
		#"""
			SELECT count()
			FROM flows_raw
			"""#
	"Effective Retention":
		#"""
			select (toUnixTimestamp(now()) - TimeReceived) from flows_raw ORDER BY TimeReceived limit 1
			"""#
}

_infoPanels: [{
	title: "Filtered Flows"
	type:  "stat"
	gridPos: {h: 3, w: 5, x: 0, y: 0}
	fieldConfig: defaults: unit: "short"
	fieldConfig: defaults: color: fixedColor: "green"
	fieldConfig: defaults: color: mode:       "fixed"
	targets: [{
		rawSql: _infoPanelQueries[title]
	}]
}, {
	title:       "Disk Usage"
	description: "Does not include Kafka usage (which is capped by `goflowTopicRetention` config)."
	type:        "stat"
	gridPos: {h: 3, w: 5, x: 5, y: 0}
	fieldConfig: defaults: unit: "bytes"
	fieldConfig: defaults: color: fixedColor: "purple"
	fieldConfig: defaults: color: mode:       "fixed"
	targets: [{
		rawSql: _infoPanelQueries[title]
	}]
}, {
	title: "Total Flows Stored"
	type:  "stat"
	gridPos: {h: 3, w: 5, x: 0, y: 3}
	fieldConfig: defaults: unit: "short"
	fieldConfig: defaults: color: fixedColor: "purple"
	fieldConfig: defaults: color: mode:       "fixed"
	targets: [{
		rawSql: _infoPanelQueries[title]
	}]
}, {
	title: "Effective Retention"
	type:  "stat"
	gridPos: {h: 3, w: 5, x: 5, y: 3}
	fieldConfig: defaults: unit: "dtdurations"
	fieldConfig: defaults: color: fixedColor: "purple"
	fieldConfig: defaults: color: mode:       "fixed"
	targets: [{
		rawSql: _infoPanelQueries[title]
	}]
}]

_negativeYOut: {
	matcher: {
		id:      "byRegexp"
		options: ".*out"
	}
	properties: [
		{
			id:    "custom.transform"
			value: "negative-Y"
		},
	]
}

_textBoxes: {
	srcIP:   "Src IPv6"
	dstIP:   "Dst IPv6"
	hostIP:  "Src/Dst IPv6"
	srcNet:  "Src Subnet"
	dstNet:  "Dst Subnet"
	hostNet: "Src/Dst Subnet"
	nextHop: "Next Hop IPv6"
	srcAS:   "Src AS"
	dstAS:   "Dst AS"
	extra:   "Custom SQL"
}

dashboards: [string]: D={
	_panels: [...#Panel]
	panels: [ for i, v in D._panels {
		id: i
		for _, t in #PanelStructs if t.type == v.type {
			(t & v)
		}
	}]

	templating: T={
		_list: [...#Variable]
		list: [ for v in T._list {
			for _, t in #VariableStructs if t.type == v.type {
				(t & v)
			}
		}]
	}
}

dashboards: [string]: templating: _list: [{
	label: "Datasource"
	name:  "datasource"
	query: "grafana-clickhouse-datasource"
	type:  "datasource"
},
	if #Config.fastNetMon != _|_ {
		{
			current: {
				selected: false
				text:     #Config.fastNetMon.name
				value:    #Config.fastNetMon.name
			}
			label: "Datasource"
			name:  "datasource_fnm"
			query: "influxdb"
			type:  "datasource"
		}
	}, {
		name:  "clickhouse_adhoc_query"
		query: "default.flows_raw"
		type:  "constant"
	}, {
		label:      "Sampler"
		name:       "sampler"
		type:       "query"
		includeAll: true
		query:
			#"""
				SELECT
				    toString(SamplerAddress),
						SamplerToString(SamplerAddress)
				FROM (
				    SELECT 
				        DISTINCT SamplerAddress 
				    FROM flows_raw 
				    WHERE $__timeFilter(TimeReceived)
				)
				"""#
	}, {
		label:      "Interface"
		name:       "interface"
		type:       "query"
		includeAll: true
		query:
			#"""
				SELECT
				    (toString(SamplerAddress) || '-' || toString(InIf)),
				    InterfaceToString(SamplerAddress, InIf)
				FROM (
				    SELECT DISTINCT SamplerAddress,
				                    InIf
				    FROM flows_raw
				    WHERE $__timeFilter(TimeReceived)
				)
				UNION ALL
				SELECT
				    (toString(SamplerAddress) || '-' || toString(OutIf)),
				    InterfaceToString(SamplerAddress, OutIf)
				FROM (
				    SELECT DISTINCT SamplerAddress,
				                    OutIf
				    FROM flows_raw
				    WHERE $__timeFilter(TimeReceived)
				)
				"""#
	}, {
		name:  "ad_hoc_query"
		label: "Custom Filters"
		type:  "adhoc"
	}] + [ for n, l in _textBoxes {
	#TextboxVariable & {
		name:  n
		label: l
	}
}]

dashboards: [string]: {
	annotations: list: [
		{
			builtIn: 1
			datasource: {
				type: "grafana"
				uid:  "-- Grafana --"
			}
			enable:    true
			hide:      true
			iconColor: "rgba(0, 211, 255, 1)"
			name:      "Annotations & Alerts"
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
	editable:             true
	fiscalYearStartMonth: 0
	graphTooltip:         0
	liveNow:              false
	schemaVersion:        37
	style:                "dark"
	tags: ["netmeta"]
	time: {
		from: "now-6h"
		to:   "now"
	}
	timepicker: {}
	timezone:  ""
	version:   1
	weekStart: ""
	links: [{
		asDropdown:  false
		icon:        "external link"
		includeVars: true
		keepTime:    true
		tags: [
			"netmeta",
		]
		targetBlank: false
		title:       "NetMeta Dashboards"
		tooltip:     ""
		type:        "dashboards"
		url:         ""
	}]
}

postData: {
	for n, v in dashboards {
		"\(n)": {
			dashboard: v
			folderId:  0
			overwrite: true
		}
	}
}