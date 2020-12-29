package netmeta_overview

_datasource: "NetMeta ClickHouse"

{
	"annotations": {
		"list": [
			{
				"builtIn":    1
				"datasource": "-- Grafana --"
				"enable":     true
				"hide":       true
				"iconColor":  "rgba(0, 211, 255, 1)"
				"name":       "Annotations & Alerts"
				"type":       "dashboard"
			},
		]
	}
	"editable":     true
	"gnetId":       null
	"graphTooltip": 1
	"id":           1
	"title":        "NetMeta Overview"
	"uid":          "9Dw5dGzGk"
	"links": []
	"panels": [
		{
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align": null
					}
					"mappings": []
					"thresholds": {
						"mode": "absolute"
						"steps": [
							{
								"color": "green"
								"value": null
							},
						]
					}
					"unit": "short"
				}
				"overrides": []
			}
			"gridPos": {
				"h": 3
				"w": 5
				"x": 0
				"y": 0
			}
			"id": 37
			"options": {
				"colorMode":   "value"
				"graphMode":   "area"
				"justifyMode": "auto"
				"orientation": "auto"
				"reduceOptions": {
					"calcs": [
						"mean",
					]
					"values": true
				}
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     "Date"
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT count()\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Filtered Flows "
			"type":      "stat"
		},
		{
			"datasource":  _datasource
			"description": "Does not include Kafka usage (which is capped by `goflowTopicRetention` config)."
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align": null
					}
					"mappings": []
					"thresholds": {
						"mode": "absolute"
						"steps": [
							{
								"color": "purple"
								"value": null
							},
						]
					}
					"unit": "bytes"
				}
				"overrides": []
			}
			"gridPos": {
				"h": 3
				"w": 5
				"x": 5
				"y": 0
			}
			"id": 38
			"options": {
				"colorMode":   "value"
				"graphMode":   "area"
				"justifyMode": "auto"
				"orientation": "auto"
				"reduceOptions": {
					"calcs": [
						"mean",
					]
					"values": true
				}
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "FlowReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "select sum(bytes_on_disk) from system.parts"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Disk Usage"
			"type":      "stat"
		},
		{
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align": null
					}
					"mappings": []
					"thresholds": {
						"mode": "absolute"
						"steps": [
							{
								"color": "purple"
								"value": null
							},
						]
					}
					"unit": "short"
				}
				"overrides": []
			}
			"gridPos": {
				"h": 3
				"w": 5
				"x": 0
				"y": 3
			}
			"id": 24
			"options": {
				"colorMode":   "value"
				"graphMode":   "area"
				"justifyMode": "auto"
				"orientation": "auto"
				"reduceOptions": {
					"calcs": [
						"mean",
					]
					"values": true
				}
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "FlowReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT count()\nFROM $table"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Total Flows Stored"
			"type":      "stat"
		},
		{
			"datasource":  _datasource
			"description": ""
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align": null
					}
					"mappings": []
					"thresholds": {
						"mode": "absolute"
						"steps": [
							{
								"color": "purple"
								"value": null
							},
						]
					}
					"unit": "dtdurations"
				}
				"overrides": []
			}
			"gridPos": {
				"h": 3
				"w": 5
				"x": 5
				"y": 3
			}
			"id": 39
			"options": {
				"colorMode":   "value"
				"graphMode":   "area"
				"justifyMode": "auto"
				"orientation": "auto"
				"reduceOptions": {
					"calcs": [
						"mean",
					]
					"values": true
				}
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "FlowReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "select (toUnixTimestamp(now()) - TimeReceived) from flows_raw order by TimeReceived limit 1"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Effective Retention"
			"type":      "stat"
		},
		{
			"collapsed":  false
			"datasource": _datasource
			"gridPos": {
				"h": 1
				"w": 24
				"x": 0
				"y": 6
			}
			"id": 16
			"panels": []
			"title": "Traffic Statistics"
			"type":  "row"
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 7
			}
			"hiddenSeries": false
			"id":           2
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:86"
					"alias":     "out"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    sum(Packets * SamplingRate) / $interval AS Packets,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Packets "
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"transformations": []
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:783"
					"format":    "pps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:784"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 7
			}
			"hiddenSeries": false
			"id":           4
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:141"
					"alias":     "out"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Throughput"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 19
			}
			"hiddenSeries": false
			"id":           8
			"legend": {
				"alignAsTable": false
				"avg":          false
				"current":      false
				"hideEmpty":    false
				"hideZero":     false
				"max":          false
				"min":          false
				"rightSide":    false
				"show":         true
				"sort":         "current"
				"sortDesc":     true
				"total":        false
				"values":       false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:196"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) || ' (' || toString(Proto) || ')' AS Proto,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, Proto, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "IP Proto"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 19
			}
			"hiddenSeries": false
			"id":           28
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:196"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    dictGetString('EtherTypes', 'Name', toUInt64(EType)) || ' (' || hex(EType) || ')' AS EType,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, EType, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Ethernet Type"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 31
			}
			"hiddenSeries": false
			"id":           11
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": []
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    count(*) / $interval AS Flows,\n    SamplerAddress\nFROM $table\nWHERE\n    $timeFilter\n    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n    $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    $conditionalTest(AND ($extra), $extra)\nGROUP BY\n    t, SamplerAddress\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Raw Flows/s Per Host"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "pps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 31
			}
			"hiddenSeries": false
			"id":           12
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": []
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    NextHop,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps\nFROM $table\nWHERE $timeFilter AND NextHop != toIPv6('::')\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, NextHop\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Traffic per Next Hop"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 43
			}
			"hiddenSeries": false
			"id":           13
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:257"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    SamplerAddress,\n    toString(InIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), InIf)) || ')' AS InIf,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, SamplerAddress, InIf, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Traffic per Ingress Interface"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 43
			}
			"hiddenSeries": false
			"id":           14
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:257"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    SamplerAddress,\n    toString(OutIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), OutIf)) || ')' AS OutIf,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, SamplerAddress, OutIf, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Traffic per Egress Interface"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"collapsed":  false
			"datasource": _datasource
			"gridPos": {
				"h": 1
				"w": 24
				"x": 0
				"y": 55
			}
			"id": 20
			"panels": []
			"title": "Origin AS Stats"
			"type":  "row"
		},
		{
			"datasource":  _datasource
			"description": ""
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align":       null
						"displayMode": "auto"
					}
					"mappings": []
					"thresholds": {
						"mode": "percentage"
						"steps": [
							{
								"color": "green"
								"value": null
							},
							{
								"color": "red"
								"value": 80
							},
						]
					}
				}
				"overrides": [
					{
						"matcher": {
							"id":      "byName"
							"options": "Bytes"
						}
						"properties": [
							{
								"id":    "custom.displayMode"
								"value": "gradient-gauge"
							},
							{
								"id":    "unit"
								"value": "kbytes"
							},
							{
								"id": "max"
							},
						]
					},
				]
			}
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 56
			}
			"id": 5
			"options": {
				"showHeader": true
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT \n  SrcAS,\n  sum(Bytes * SamplingRate) / 1024 as Bytes\nFROM $table\nWHERE $timeFilter AND FlowDirection = 0\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY SrcAS\nORDER BY Bytes DESC\nLIMIT 100\n"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Top Source ASNs"
			"transformations": []
			"type": "table"
		},
		{
			"datasource":  _datasource
			"description": ""
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align":       null
						"displayMode": "auto"
					}
					"mappings": []
					"thresholds": {
						"mode": "percentage"
						"steps": [
							{
								"color": "green"
								"value": null
							},
							{
								"color": "red"
								"value": 80
							},
						]
					}
				}
				"overrides": [
					{
						"matcher": {
							"id":      "byName"
							"options": "Bytes"
						}
						"properties": [
							{
								"id":    "custom.displayMode"
								"value": "gradient-gauge"
							},
							{
								"id":    "unit"
								"value": "kbytes"
							},
							{
								"id": "max"
							},
						]
					},
				]
			}
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 56
			}
			"id": 6
			"options": {
				"showHeader": true
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT \n  DstAS,\n  sum(Bytes * SamplingRate) / 1024 as Bytes\nFROM $table\nWHERE $timeFilter AND FlowDirection = 1\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY DstAS\nORDER BY Bytes DESC\nLIMIT 101"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Top Destination ASNs"
			"transformations": []
			"type": "table"
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 68
			}
			"hiddenSeries": false
			"id":           25
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": []
			"spaceLength": 10
			"stack":       true
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    SrcAS,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps\nFROM $table\nWHERE\n    $timeFilter AND FlowDirection = 0\n    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n    $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    AND SrcAS IN (\n    SELECT SrcAS\n    FROM $table\n    WHERE $timeFilter AND FlowDirection = 0 AND $adhoc\n      $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n      $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n      $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n      $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n      $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n      $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n      $conditionalTest(AND ($extra), $extra)\n    GROUP BY SrcAS\n    ORDER BY count(*) DESC\n    LIMIT 10)\n    $conditionalTest(AND ($extra), $extra)\nGROUP BY\n    t,\n    SrcAS\nORDER BY t, Bps"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Top 10 Source ASN"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 68
			}
			"hiddenSeries": false
			"id":           30
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": []
			"spaceLength": 10
			"stack":       true
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    DstAS,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps\nFROM $table\nWHERE\n    $timeFilter AND FlowDirection = 1\n    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n    $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    AND DstAS IN (\n    SELECT DstAS\n    FROM $table\n    WHERE $timeFilter AND FlowDirection = 1 AND $adhoc\n      $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n      $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n      $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n      $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n      $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n      $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    GROUP BY DstAS\n    ORDER BY count(*) DESC\n    LIMIT 10)\n    $conditionalTest(AND ($extra), $extra)\nGROUP BY\n    t,\n    DstAS\nORDER BY t, Bps"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Top 10 Destination ASN"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"collapsed":  false
			"datasource": _datasource
			"gridPos": {
				"h": 1
				"w": 24
				"x": 0
				"y": 80
			}
			"id": 27
			"panels": []
			"title": "Traffic Details (expensive)"
			"type":  "row"
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 81
			}
			"hiddenSeries": false
			"id":           31
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:196"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    \n    arrayStringConcat(\n      arrayMap(\n        x -> dictGetString('TCPFlags', 'Name', toUInt64(x)), bitmaskToArray(TCPFlags))\n      , '-')\n    || ' (' || toString(TCPFlags) || ')' AS TCPFlags,\n    \n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter AND Proto = 6\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, TCPFlags, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "TCP Flags"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 81
			}
			"hiddenSeries": false
			"id":           32
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:196"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    VlanId,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY t, VlanId, FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "VLAN ID"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 93
			}
			"hiddenSeries": false
			"id":           29
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:251"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    SrcPort,\n    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS Proto,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE\n    $timeFilter\n    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n    $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    AND SrcPort IN (\n    SELECT SrcPort\n    FROM $table\n    WHERE $timeFilter AND $adhoc\n      $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n      $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n      $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n      $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n      $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n      $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    GROUP BY SrcPort\n    ORDER BY count(*) DESC\n    LIMIT 10)\n    $conditionalTest(AND ($extra), $extra)\nGROUP BY\n    t,\n    Proto,\n    SrcPort, \n    FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Top 10 Source Ports"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"transformations": []
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 93
			}
			"hiddenSeries": false
			"id":           9
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:251"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    DstPort, \n    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS Proto,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE\n    $timeFilter\n    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n    $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    AND DstPort IN (\n    SELECT DstPort\n    FROM $table\n    WHERE $timeFilter AND $adhoc\n      $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n      $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n      $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n      $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n      $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n      $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n      $conditionalTest(AND ($extra), $extra)\n    GROUP BY DstPort\n    ORDER BY count(*) DESC\n    LIMIT 10)\n    $conditionalTest(AND ($extra), $extra)\nGROUP BY\n    t,\n    Proto,\n    DstPort,\n    FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Top 10 Destination Ports"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 0
				"y": 105
			}
			"hiddenSeries": false
			"id":           33
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:251"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    SrcAddr,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE\n    $timeFilter\n    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n    $conditionalTest(AND DstAddr = toIPv6('$hostIP'), $hostIP)\n    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    AND SrcAddr IN (\n    SELECT SrcAddr\n    FROM $table\n    WHERE $timeFilter AND $adhoc\n      $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n      $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n      $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n      $conditionalTest(AND DstAddr = toIPv6('$hostIP'), $hostIP)\n      $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n      $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n      $conditionalTest(AND ($extra), $extra)\n    GROUP BY SrcAddr\n    ORDER BY sum(Bytes) DESC\n    LIMIT 10)\n    $conditionalTest(AND ($extra), $extra)\nGROUP BY\n    t,\n    SrcAddr, \n    FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Top 10 Source IPs"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"transformations": []
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"aliasColors": {}
			"bars":       false
			"dashLength": 10
			"dashes":     false
			"datasource": _datasource
			"fieldConfig": {
				"defaults": {
					"custom": {}
				}
				"overrides": []
			}
			"fill":         1
			"fillGradient": 0
			"gridPos": {
				"h": 12
				"w": 12
				"x": 12
				"y": 105
			}
			"hiddenSeries": false
			"id":           34
			"legend": {
				"avg":     false
				"current": false
				"max":     false
				"min":     false
				"show":    true
				"total":   false
				"values":  false
			}
			"lines":         true
			"linewidth":     1
			"nullPointMode": "null"
			"options": {
				"dataLinks": []
			}
			"percentage":  false
			"pointradius": 2
			"points":      false
			"renderer":    "flot"
			"seriesOverrides": [
				{
					"$$hashKey": "object:251"
					"alias":     "/, out/"
					"transform": "negative-Y"
				},
			]
			"spaceLength": 10
			"stack":       false
			"steppedLine": false
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "time_series"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT\n    $timeSeries as t,\n    DstAddr,\n    sum(Bytes * SamplingRate) * 8 / $interval AS Bps,\n    if(FlowDirection == 1, 'out', 'in') AS FlowDirection\nFROM $table\nWHERE\n    $timeFilter\n    $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n    $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n    $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n    $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n    $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n    $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n    AND DstAddr IN (\n    SELECT DstAddr\n    FROM $table\n    WHERE $timeFilter AND $adhoc\n      $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n      $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n      $conditionalTest(AND SrcAddr = toIPv6('$hostIP'), $hostIP)\n      $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n      $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n      $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n      $conditionalTest(AND ($extra), $extra)\n    GROUP BY DstAddr\n    ORDER BY sum(Bytes) DESC\n    LIMIT 10)\n    $conditionalTest(AND ($extra), $extra)\nGROUP BY\n    t,\n    DstAddr, \n    FlowDirection\nORDER BY t"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"thresholds": []
			"timeFrom": null
			"timeRegions": []
			"timeShift": null
			"title":     "Top 10 Destination IPs"
			"tooltip": {
				"shared":     true
				"sort":       0
				"value_type": "individual"
			}
			"transformations": []
			"type": "graph"
			"xaxis": {
				"buckets": null
				"mode":    "time"
				"name":    null
				"show":    true
				"values": []
			}
			"yaxes": [
				{
					"$$hashKey": "object:639"
					"format":    "bps"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
				{
					"$$hashKey": "object:640"
					"format":    "short"
					"label":     null
					"logBase":   1
					"max":       null
					"min":       null
					"show":      true
				},
			]
			"yaxis": {
				"align":      false
				"alignLevel": null
			}
		},
		{
			"collapsed":  false
			"datasource": _datasource
			"gridPos": {
				"h": 1
				"w": 24
				"x": 0
				"y": 117
			}
			"id": 18
			"panels": []
			"title": "Top Hosts (expensive)"
			"type":  "row"
		},
		{
			"datasource":  _datasource
			"description": ""
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align":       null
						"displayMode": "auto"
					}
					"mappings": []
					"thresholds": {
						"mode": "percentage"
						"steps": [
							{
								"color": "green"
								"value": null
							},
							{
								"color": "red"
								"value": 80
							},
						]
					}
				}
				"overrides": [
					{
						"matcher": {
							"id":      "byName"
							"options": "Bytes"
						}
						"properties": [
							{
								"id":    "custom.displayMode"
								"value": "gradient-gauge"
							},
							{
								"id":    "unit"
								"value": "kbytes"
							},
							{
								"id": "max"
							},
							{
								"id":    "custom.width"
								"value": null
							},
						]
					},
				]
			}
			"gridPos": {
				"h": 14
				"w": 12
				"x": 0
				"y": 118
			}
			"id": 7
			"options": {
				"showHeader": true
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT \n  SamplerAddress,\n  SrcAddr,\n  sum(Bytes * SamplingRate) / 1024 as Bytes\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$hostIP'), $hostIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY SamplerAddress, SrcAddr\nORDER BY Bytes DESC\nLIMIT 20\n"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Top Source IPs"
			"transformations": []
			"type": "table"
		},
		{
			"datasource":  _datasource
			"description": ""
			"fieldConfig": {
				"defaults": {
					"custom": {
						"align":       null
						"displayMode": "auto"
					}
					"mappings": []
					"thresholds": {
						"mode": "percentage"
						"steps": [
							{
								"color": "green"
								"value": null
							},
							{
								"color": "red"
								"value": 80
							},
						]
					}
				}
				"overrides": [
					{
						"matcher": {
							"id":      "byName"
							"options": "Bytes"
						}
						"properties": [
							{
								"id":    "custom.displayMode"
								"value": "gradient-gauge"
							},
							{
								"id":    "unit"
								"value": "kbytes"
							},
							{
								"id": "max"
							},
						]
					},
				]
			}
			"gridPos": {
				"h": 14
				"w": 12
				"x": 12
				"y": 118
			}
			"id": 3
			"options": {
				"showHeader": true
			}
			"pluginVersion": "7.0.0"
			"targets": [
				{
					"database":            "default"
					"dateColDataType":     ""
					"dateLoading":         false
					"dateTimeColDataType": "TimeReceived"
					"dateTimeType":        "DATETIME"
					"datetimeLoading":     false
					"format":              "table"
					"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
					"intervalFactor":      1
					"query":               "SELECT \n  SamplerAddress,\n  DstAddr,\n  sum(Bytes * SamplingRate) / 1024 as Bytes\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND SrcAddr = toIPv6('$hostIP'), $hostIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY SamplerAddress, DstAddr\nORDER BY Bytes DESC\nLIMIT 20\n"
					"refId":               "A"
					"round":               "0s"
					"table":               "flows_raw"
					"tableLoading":        false
				},
			]
			"timeFrom":  null
			"timeShift": null
			"title":     "Top Destination IPs"
			"transformations": []
			"type": "table"
		},
		{
			"collapsed":  true
			"datasource": _datasource
			"gridPos": {
				"h": 1
				"w": 24
				"x": 0
				"y": 132
			}
			"id": 36
			"panels": [
				{
					"datasource":  _datasource
					"description": ""
					"fieldConfig": {
						"defaults": {
							"custom": {
								"align":       null
								"displayMode": "auto"
							}
							"mappings": []
							"thresholds": {
								"mode": "percentage"
								"steps": [
									{
										"color": "green"
										"value": null
									},
									{
										"color": "red"
										"value": 80
									},
								]
							}
						}
						"overrides": [
							{
								"matcher": {
									"id":      "byName"
									"options": "Bytes"
								}
								"properties": [
									{
										"id":    "custom.displayMode"
										"value": "gradient-gauge"
									},
									{
										"id":    "unit"
										"value": "kbytes"
									},
									{
										"id": "max"
									},
								]
							},
						]
					}
					"gridPos": {
						"h": 12
						"w": 24
						"x": 0
						"y": 130
					}
					"id": 10
					"options": {
						"showHeader": true
					}
					"pluginVersion": "7.0.0"
					"targets": [
						{
							"database":            "default"
							"dateColDataType":     ""
							"dateLoading":         false
							"dateTimeColDataType": "TimeReceived"
							"dateTimeType":        "DATETIME"
							"datetimeLoading":     false
							"format":              "table"
							"formattedQuery":      "SELECT $timeSeries as t, count() FROM $table WHERE $timeFilter GROUP BY t ORDER BY t"
							"intervalFactor":      1
							"query":               "SELECT \n  SamplerAddress,\n  SrcAddr,\n  DstAddr,\n  SrcPort,\n  DstPort,\n  dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS Proto,\n  sum(Bytes * SamplingRate) / 1024 as Bytes\nFROM $table\nWHERE $timeFilter\n  $conditionalTest(AND SamplerAddress = toIPv6($sampler), $sampler)\n  $conditionalTest(AND SrcAddr = toIPv6('$srcIP'), $srcIP)\n  $conditionalTest(AND DstAddr = toIPv6('$dstIP'), $dstIP)\n  $conditionalTest(AND (SrcAddr = toIPv6('$hostIP') OR DstAddr = toIPv6('$hostIP')), $hostIP)\n  $conditionalTest(AND NextHop = toIPv6('$nextHop'), $nextHop)\n  $conditionalTest(AND (InIf = $interface OR OutIf = $interface), $interface)\n  $conditionalTest(AND ($extra), $extra)\nGROUP BY SamplerAddress, SrcAddr, DstAddr, SrcPort, DstPort, Proto\nORDER BY Bytes DESC\nLIMIT 20\n"
							"refId":               "A"
							"round":               "0s"
							"table":               "flows_raw"
							"tableLoading":        false
						},
					]
					"timeFrom":  null
					"timeShift": null
					"title":     "Top Flows"
					"transformations": []
					"type": "table"
				},
			]
			"title": "Top Flows (very expensive)"
			"type":  "row"
		},
	]
	"refresh":       false
	"schemaVersion": 25
	"style":         "dark"
	"tags": []
	"templating": {
		"list": [
			{
				"current": {
					"value": "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
					"text":  "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
				}
				"hide":  2
				"label": null
				"name":  "adhoc_query_filter"
				"options": [
					{
						"value": "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
						"text":  "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
					},
				]
				"query":       "SELECT database, table, name, type FROM system.columns WHERE table='flows_raw' ORDER BY database, table"
				"skipUrlSync": false
				"type":        "constant"
			},
			{
				"allValue": null
				"current": {}
				"datasource": _datasource
				"definition": "SELECT DISTINCT IPv6NumToString(SamplerAddress) FROM flows_raw WHERE $timeFilterByColumn(TimeReceived)"
				"hide":       0
				"includeAll": true
				"label":      "Source"
				"multi":      false
				"name":       "sampler"
				"options": []
				"query":          "SELECT DISTINCT IPv6NumToString(SamplerAddress) FROM flows_raw WHERE $timeFilterByColumn(TimeReceived)"
				"refresh":        2
				"regex":          ""
				"skipUrlSync":    false
				"sort":           0
				"tagValuesQuery": ""
				"tags": []
				"tagsQuery": ""
				"type":      "query"
				"useTags":   false
			},
			{
				"allValue": null
				"current": {}
				"datasource": _datasource
				"definition": "SELECT toString(InIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), InIf)) || ')' AS __text, InIf AS __value FROM (SELECT DISTINCT SamplerAddress, InIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))\nUNION ALL\nSELECT toString(OutIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), OutIf)) || ')' AS __text, OutIf AS __value FROM (SELECT DISTINCT SamplerAddress, OutIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))"
				"hide":       0
				"includeAll": true
				"label":      "Interface"
				"multi":      false
				"name":       "interface"
				"options": []
				"query":          "SELECT toString(InIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), InIf)) || ')' AS __text, InIf AS __value FROM (SELECT DISTINCT SamplerAddress, InIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))\nUNION ALL\nSELECT toString(OutIf) || ' (' || dictGetString('InterfaceNames', 'Description', (IPv6NumToString(SamplerAddress), OutIf)) || ')' AS __text, OutIf AS __value FROM (SELECT DISTINCT SamplerAddress, OutIf FROM flows_raw WHERE $timeFilterByColumn(TimeReceived))"
				"refresh":        2
				"regex":          ""
				"skipUrlSync":    false
				"sort":           0
				"tagValuesQuery": ""
				"tags": []
				"tagsQuery": ""
				"type":      "query"
				"useTags":   false
			},
			{
				"datasource": "NetMeta ClickHouse"
				"filters": []
				"hide":        0
				"label":       "Custom filters"
				"name":        "adhoc_query"
				"skipUrlSync": false
				"type":        "adhoc"
			},
			{
				"current": {
					"selected": false
					"text":     ""
					"value":    ""
				}
				"hide":  0
				"label": "Src IPv6"
				"name":  "srcIP"
				"options": [
					{
						"selected": false
						"text":     ""
						"value":    ""
					},
				]
				"query":       ""
				"skipUrlSync": false
				"type":        "textbox"
			},
			{
				"current": {
					"selected": false
					"text":     ""
					"value":    ""
				}
				"hide":  0
				"label": "Dst IPv6"
				"name":  "dstIP"
				"options": [
					{
						"selected": false
						"text":     ""
						"value":    ""
					},
				]
				"query":       ""
				"skipUrlSync": false
				"type":        "textbox"
			},
			{
				"current": {
					"selected": false
					"text":     ""
					"value":    ""
				}
				"hide":  0
				"label": "Src/Dst IPv6"
				"name":  "hostIP"
				"options": [
					{
						"selected": true
						"text":     ""
						"value":    ""
					},
				]
				"query":       ""
				"skipUrlSync": false
				"type":        "textbox"
			},
			{
				"current": {
					"selected": true
					"text":     ""
					"value":    ""
				}
				"hide":  0
				"label": "Next Hop IPv6"
				"name":  "nextHop"
				"options": [
					{
						"selected": true
						"text":     ""
						"value":    ""
					},
				]
				"query":       ""
				"skipUrlSync": false
				"type":        "textbox"
			},
			{
				"current": {
					"selected": true
					"text":     ""
					"value":    ""
				}
				"hide":  0
				"label": "Custom SQL"
				"name":  "extra"
				"options": [
					{
						"selected": true
						"text":     ""
						"value":    ""
					},
				]
				"query":       ""
				"skipUrlSync": false
				"type":        "textbox"
			},
		]
	}
	"time": {
		"from": "now-3h"
		"to":   "now"
	}
	"timepicker": {
		"refresh_intervals": [
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
	}
}
