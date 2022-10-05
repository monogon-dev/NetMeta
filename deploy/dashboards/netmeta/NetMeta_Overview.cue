package netmeta

dashboards: "NetMeta Overview": {
	editable:     true
	gnetId:       null
	graphTooltip: 1
	links: []
	panels: [{
		datasource: "$datasource"
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
		datasource:  "$datasource"
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
		datasource: "$datasource"
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
		datasource:  "$datasource"
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
				For questions, bug reports or feature requests please refer to https://github.com/monogon-dev/NetMeta or send a mail to netmeta@leoluk.de

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
		datasource: "$datasource"
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
		datasource: "$datasource"
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
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, FlowDirectionStr
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
		datasource: "$datasource"
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
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, FlowDirectionStr
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
		datasource: "$datasource"
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
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) || ' (' || toString(Proto) || ')' AS ProtoName,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, ProtoName, FlowDirectionStr
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
		datasource: "$datasource"
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
			    dictGetString('EtherTypes', 'Name', toUInt64(EType)) || ' (' || hex(EType) || ')' AS ETypeName,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, ETypeName, FlowDirectionStr
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
		datasource: "$datasource"
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
		datasource: "$datasource"
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
		datasource: "$datasource"
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
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, SamplerAddress, InIf, FlowDirectionStr
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
		datasource: "$datasource"
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
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, SamplerAddress, OutIf, FlowDirectionStr
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
		datasource: "$datasource"
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
		datasource:  "$datasource"
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
			}, {
				matcher: {
					id:      "byName"
					options: "CO"
				}
				properties: [{
					id:    "custom.width"
					value: 42
				}]
			}, {
				matcher: {
					id:      "byName"
					options: "SrcAS"
				}
				properties: [{
					id:    "custom.width"
					value: 100
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
			  dictGetString('autnums', 'name', toUInt64(SrcAS)) AS ASName,
			  dictGetString('autnums', 'country', toUInt64(SrcAS)) AS CO,
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
		datasource:  "$datasource"
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
			}, {
				matcher: {
					id:      "byName"
					options: "CO"
				}
				properties: [{
					id:    "custom.width"
					value: 42
				}]
			}, {
				matcher: {
					id:      "byName"
					options: "SrcAS"
				}
				properties: [{
					id:    "custom.width"
					value: 100
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
			  dictGetString('autnums', 'name', toUInt64(DstAS)) AS ASName,
			  dictGetString('autnums', 'country', toUInt64(DstAS)) AS CO,
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
		datasource: "$datasource"
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
		datasource: "$datasource"
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
		collapsed:  true
		datasource: "$datasource"
		gridPos: {
			h: 1
			w: 24
			x: 0
			y: 80
		}
		id: 27
		panels: [{
			aliasColors: {}
			bars:       false
			dashLength: 10
			dashes:     false
			datasource: "$datasource"
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
			    || ' (' || toString(TCPFlags) || ')' AS TCPFlagsName,

			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter AND Proto = 6
			\(_genericFilter)
			GROUP BY t, TCPFlagsName, FlowDirectionStr
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
			datasource: "$datasource"
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
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, VlanId, FlowDirectionStr
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
			datasource: "$datasource"
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
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS ProtoName,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
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
			    ProtoName,
			    SrcPort,
			    FlowDirectionStr
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
			datasource: "$datasource"
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
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS ProtoName,
			    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
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
			    ProtoName,
			    DstPort,
			    FlowDirectionStr
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
			datasource: "$datasource"
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
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
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
			    FlowDirectionStr
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
			datasource: "$datasource"
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
			    if(FlowDirection == 1, 'out', 'in') AS FlowDirectionStr
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
			    FlowDirectionStr
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
		}]
		title: "Traffic Details (expensive)"
		type:  "row"
	}, {
		collapsed:  true
		datasource: "$datasource"
		gridPos: {
			h: 1
			w: 24
			x: 0
			y: 81
		}
		id: 18
		panels: [{
			datasource:  "$datasource"
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
			datasource:  "$datasource"
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
		}]
		title: "Top Hosts (expensive)"
		type:  "row"
	}, {
		collapsed:  true
		datasource: "$datasource"
		gridPos: {
			h: 1
			w: 24
			x: 0
			y: 82
		}
		id: 36
		panels: [{
			datasource:  "$datasource"
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
				  dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS ProtoName,
				  sum(Bytes * SamplingRate) / 1024 as Bytes
				FROM $table
				WHERE $timeFilter
				\(_genericFilter)
				GROUP BY SamplerAddress, SrcAddr, DstAddr, SrcPort, DstPort, ProtoName
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
	}, {
		collapsed:  true
		datasource: null
		gridPos: {
			h: 1
			w: 24
			x: 0
			y: 83
		}
		id: 41
		panels: [{
			cards: {
				cardPadding: 0
				cardRound:   0
			}
			color: {
				cardColor:   "#b4ff00"
				colorScale:  "sqrt"
				colorScheme: "interpolateTurbo"
				exponent:    0.5
				max:         null
				min:         null
				mode:        "spectrum"
			}
			dataFormat: "timeseries"
			datasource: "$datasource"
			fieldConfig: {
				defaults: {
					custom: {}
					links: []
				}
				overrides: []
			}
			gridPos: {
				h: 12
				w: 12
				x: 0
				y: 134
			}
			heatmap: {}
			hideZeroBuckets: true
			highlightCards:  true
			id:              45
			legend: show: false
			pluginVersion:   "7.3.6"
			reverseYBuckets: false
			targets: [{
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
				    IPTTL as b
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, IPTTL
			ORDER BY t
			"""
				refId:               "A"
				round:               "0s"
				table:               "flows_raw"
				tableLoading:        false
			}]
			timeFrom:  null
			timeShift: null
			title:     "IP TTL"
			tooltip: {
				show:          true
				showHistogram: false
			}
			type: "heatmap"
			xAxis: show: true
			xBucketNumber: 150
			xBucketSize:   ""
			yAxis: {
				decimals:    null
				format:      "short"
				logBase:     1
				max:         "255"
				min:         "0"
				show:        true
				splitFactor: null
			}
			yBucketBound:  "auto"
			yBucketNumber: null
			yBucketSize:   1
		}, {
			cards: {
				cardPadding: 0
				cardRound:   0
			}
			color: {
				cardColor:   "#b4ff00"
				colorScale:  "sqrt"
				colorScheme: "interpolateTurbo"
				exponent:    0.5
				min:         null
				mode:        "spectrum"
			}
			dataFormat: "timeseries"
			datasource: "$datasource"
			fieldConfig: {
				defaults: {
					custom: {}
					links: []
				}
				overrides: []
			}
			gridPos: {
				h: 12
				w: 12
				x: 12
				y: 134
			}
			heatmap: {}
			hideZeroBuckets: true
			highlightCards:  true
			id:              46
			legend: show: false
			pluginVersion:   "7.3.6"
			reverseYBuckets: false
			targets: [{
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
				    Bytes as b
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, Bytes
			ORDER BY t
			"""
				refId:               "A"
				round:               "0s"
				table:               "flows_raw"
				tableLoading:        false
			}]
			timeFrom:  null
			timeShift: null
			title:     "Packet Size (Bytes)"
			tooltip: {
				show:          true
				showHistogram: false
			}
			type: "heatmap"
			xAxis: show: true
			xBucketNumber: 150
			xBucketSize:   ""
			yAxis: {
				decimals:    null
				format:      "short"
				logBase:     1
				max:         "\(#Config.maxPacketSize)"
				min:         "0"
				show:        true
				splitFactor: null
			}
			yBucketBound:  "auto"
			yBucketNumber: null
			yBucketSize:   10
		}, {
			cards: {
				cardPadding: 0
				cardRound:   0
			}
			color: {
				cardColor:   "#b4ff00"
				colorScale:  "sqrt"
				colorScheme: "interpolateTurbo"
				exponent:    0.5
				min:         null
				mode:        "spectrum"
			}
			dataFormat: "timeseries"
			datasource: "$datasource"
			fieldConfig: {
				defaults: {
					custom: {}
					links: []
				}
				overrides: []
			}
			gridPos: {
				h: 12
				w: 12
				x: 0
				y: 146
			}
			heatmap: {}
			hideZeroBuckets: true
			highlightCards:  true
			id:              47
			legend: show: false
			pluginVersion:   "7.3.6"
			reverseYBuckets: false
			targets: [{
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
				    SrcPort as b
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, SrcPort
			ORDER BY t
			"""
				refId:               "A"
				round:               "0s"
				table:               "flows_raw"
				tableLoading:        false
			}]
			timeFrom:  null
			timeShift: null
			title:     "Source Port"
			tooltip: {
				show:          true
				showHistogram: false
			}
			type: "heatmap"
			xAxis: show: true
			xBucketNumber: 150
			xBucketSize:   ""
			yAxis: {
				decimals:    null
				format:      "short"
				logBase:     1
				max:         "65535"
				min:         "0"
				show:        true
				splitFactor: null
			}
			yBucketBound:  "auto"
			yBucketNumber: null
			yBucketSize:   1000
		}, {
			cards: {
				cardPadding: 0
				cardRound:   0
			}
			color: {
				cardColor:   "#b4ff00"
				colorScale:  "sqrt"
				colorScheme: "interpolateTurbo"
				exponent:    0.5
				min:         null
				mode:        "spectrum"
			}
			dataFormat: "timeseries"
			datasource: "$datasource"
			fieldConfig: {
				defaults: {
					custom: {}
					links: []
				}
				overrides: []
			}
			gridPos: {
				h: 12
				w: 12
				x: 12
				y: 146
			}
			heatmap: {}
			hideZeroBuckets: true
			highlightCards:  true
			id:              48
			legend: show: false
			pluginVersion:   "7.3.6"
			reverseYBuckets: false
			targets: [{
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
				    DstPort as b
			FROM $table
			WHERE $timeFilter
			\(_genericFilter)
			GROUP BY t, DstPort
			ORDER BY t
			"""
				refId:               "A"
				round:               "0s"
				table:               "flows_raw"
				tableLoading:        false
			}]
			timeFrom:  null
			timeShift: null
			title:     "Destination Port"
			tooltip: {
				show:          true
				showHistogram: false
			}
			type: "heatmap"
			xAxis: show: true
			xBucketNumber: 150
			xBucketSize:   ""
			yAxis: {
				decimals:    null
				format:      "short"
				logBase:     1
				max:         "65535"
				min:         "0"
				show:        true
				splitFactor: null
			}
			yBucketBound:  "auto"
			yBucketNumber: null
			yBucketSize:   1000
		}]
		title: "Heatmaps (may induce spontaneous browser combustion)"
		type:  "row"
	}]
	refresh:       false
	schemaVersion: 26
	style:         "dark"
	tags: []
	time: {
		from: "now-3h"
		to:   "now"
	}
	timepicker: refresh_intervals: ["10s", "30s", "1m", "5m", "15m", "30m", "1h", "2h", "1d"]
	timezone: ""
	uid:      "9Dw5dGzGk"
}
