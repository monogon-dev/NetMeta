package dashboards

_trafficStatisticQueries: {
	Packets:
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    (sum(Packets * SamplingRate) / $__interval_s) AS Value,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			GROUP BY time, FlowDirection
			ORDER BY time
			"""#
	Throughput:
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS Value,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			GROUP BY time, FlowDirection
			ORDER BY time
			"""#
	"IP Proto":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) || ' (' || toString(Proto) || ')' AS ProtoName,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS BitsPerSecond,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			GROUP BY time, Proto, FlowDirection
			ORDER BY time
			"""#
	"Ethernet Type":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    dictGetString('EtherTypes', 'Name', toUInt64(EType)) || ' (' || hex(EType) || ')' AS ETypeName,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS BitsPerSecond,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			GROUP BY time, EType, FlowDirection
			ORDER BY time
			"""#
	"Raw Flows/s Per Host":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    (count(*) / $__interval_s) AS Flows,
			    if($showHostnames, SamplerToString(SamplerAddress), IPv6ToString(SamplerAddress)) as Sampler
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			GROUP BY time, SamplerAddress
			ORDER BY time
			"""#
	"Traffic per Next Hop":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    NextHop,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS BitsPerSecond
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			AND NextHop != toIPv6('::')
			GROUP BY time, NextHop
			ORDER BY time
			"""#
	"Traffic per Ingress Interface":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    InterfaceToString(SamplerAddress, InIf) AS InIfName,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS BitsPerSecond,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			GROUP BY time, SamplerAddress, InIf, FlowDirection
			ORDER BY time
			"""#
	"Traffic per Egress Interface":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    InterfaceToString(SamplerAddress, OutIf) AS OutIfName,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS BitsPerSecond,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			GROUP BY time, SamplerAddress, OutIf, FlowDirection
			ORDER BY time
			"""#
}

_trafficStatistics: [{
	title: "Traffic Statistics"
	gridPos: y: 6
	type: "row"
}, {
	title: "Packets"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 7}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit:        "pps"
	fieldConfig: defaults: displayName: "${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}, {
	title: "Throughput"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 7}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}, {
	title: "IP Proto"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 19}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.ProtoName} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}, {
	title: "Ethernet Type"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 19}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.ETypeName} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}, {
	title: "Raw Flows/s Per Host"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 31}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit:        "pps"
	fieldConfig: defaults: displayName: "${__field.labels.Sampler}"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}, {
	title: "Traffic per Next Hop"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 31}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit: "bps"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}, {
	title:       "Traffic per Ingress Interface"
	description: "The traffic based on the ingress interface. If you are using the portmirror, you'll see another interface with the ID 0. This is correct and is the sum of all outgoing traffic of the sampler"
	type:        "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 43}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.InIfName} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}, {
	title:       "Traffic per Egress Interface"
	description: "The traffic based on the egress interface. If you are using the portmirror, you'll see another interface with the ID 0. This is correct and is the sum of all incoming traffic of the sampler"
	type:        "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 43}
	fieldConfig: overrides: [_negativeYOut]
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.OutIfName} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficStatisticQueries[title]
	}]
}]

_originASStatisticQueries: {
	"Top 100 Source ASN":
		#"""
			SELECT
			  SrcAS,
			  dictGetString('autnums', 'name', toUInt64(SrcAS)) AS ASName,
			  dictGetString('autnums', 'country', toUInt64(SrcAS)) AS CO,
			  sum(Bytes * SamplingRate) as Bytes,
			  sum(Packets * SamplingRate) as Packets
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			AND isIncomingFlow(FlowDirection, SrcAddr, DstAddr)
			GROUP BY SrcAS
			ORDER BY Bytes DESC
			LIMIT 100
			"""#
	"Top 100 Destination ASN":
		#"""
			SELECT
			  DstAS,
			  dictGetString('autnums', 'name', toUInt64(DstAS)) AS ASName,
			  dictGetString('autnums', 'country', toUInt64(DstAS)) AS CO,
			  sum(Bytes * SamplingRate) as Bytes,
			  sum(Packets * SamplingRate) as Packets
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			AND NOT isIncomingFlow(FlowDirection, SrcAddr, DstAddr)
			GROUP BY DstAS
			ORDER BY Bytes DESC
			LIMIT 100
			"""#
	"Top 10 Source ASN":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    toString(SrcAS) as SrcASString,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS Value
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			AND isIncomingFlow(FlowDirection, SrcAddr, DstAddr)
			AND SrcAS IN (
			    SELECT SrcAS
			    FROM flows_raw
			    WHERE $__timeFilter(TimeReceived)
			      \#(_filtersWithHost)
			      AND isIncomingFlow(FlowDirection, SrcAddr, DstAddr)
			    GROUP BY SrcAS
			    ORDER BY sum(Bytes) DESC
			    LIMIT 10)
			GROUP BY time, SrcAS
			ORDER BY time, Value
			"""#
	"Top 10 Destination ASN":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    toString(DstAS) as DstASString,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS Value
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			AND NOT isIncomingFlow(FlowDirection, SrcAddr, DstAddr)
			AND DstAS IN (
			    SELECT DstAS
			    FROM flows_raw
			    WHERE $__timeFilter(TimeReceived)
			    \#(_filtersWithHost)
			    AND NOT isIncomingFlow(FlowDirection, SrcAddr, DstAddr)
			    GROUP BY DstAS
			    ORDER BY sum(Bytes) DESC
			    LIMIT 10)
			GROUP BY time, DstAS
			ORDER BY time, Value
			"""#
}

_originASStatistics: [{
	title: "Origin AS Stats"
	gridPos: y: 55
	type: "row"
}, {
	title: "Top 100 Source ASN"
	type:  "table"
	gridPos: {h: 12, w: 12, x: 0, y: 56}
	fieldConfig: defaults: color: mode: "fixed"
	fieldConfig: overrides: [{
		matcher: {
			id:      "byName"
			options: "Bytes"
		}
		properties: [{
			id:    "custom.displayMode"
			value: "gradient-gauge"
		}, {
			id:    "unit"
			value: "bytes"
		}]
	}, {
		matcher: {
			id:      "byName"
			options: "Packets"
		}
		properties: [{
			id:    "custom.displayMode"
			value: "gradient-gauge"
		}, {
			id:    "unit"
			value: "short"
		}]
	}]
	targets: [{
		rawSql: _originASStatisticQueries[title]
	}]
}, {
	title: "Top 100 Destination ASN"
	type:  "table"
	gridPos: {h: 12, w: 12, x: 12, y: 56}
	fieldConfig: defaults: color: mode: "fixed"
	fieldConfig: defaults: unit: "bytes"
	fieldConfig: overrides: [{
		matcher: {
			id:      "byName"
			options: "Bytes"
		}
		properties: [{
			id:    "custom.displayMode"
			value: "gradient-gauge"
		}, {
			id:    "unit"
			value: "bytes"
		}]
	}, {
		matcher: {
			id:      "byName"
			options: "Packets"
		}
		properties: [{
			id:    "custom.displayMode"
			value: "gradient-gauge"
		}, {
			id:    "unit"
			value: "short"
		}]
	}]

	targets: [{
		rawSql: _originASStatisticQueries[title]
	}]
}, {
	title: "Top 10 Source ASN"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 80}
	fieldConfig: defaults: unit: "bps"
	targets: [{
		rawSql: _originASStatisticQueries[title]
	}]
}, {
	title: "Top 10 Destination ASN"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 80}
	fieldConfig: defaults: unit: "bps"
	targets: [{
		rawSql: _originASStatisticQueries[title]
	}]
}]

_trafficDetailQueries: {
	"TCP Flags":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    arrayStringConcat(
			    arrayMap(
			    x -> dictGetString('TCPFlags', 'Name', toUInt64(x)), bitmaskToArray(TCPFlags))
			        , '-')
			    || ' (' || toString(TCPFlags) || ')' AS TCPFlagsName,
			
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS Value,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			AND Proto = 6
			GROUP BY time, TCPFlags, FlowDirection
			ORDER BY time
			"""#

	"VLAN ID":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    VLANToString(SamplerAddress, VlanId) AS Vlan,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS Value,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filtersWithHost)
			AND Proto = 6
			GROUP BY time, SamplerAddress, VlanId, FlowDirection
			ORDER BY time
			"""#

	"Top 10 Source Ports":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    toString(SrcPort) AS SrcPortStr,
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS ProtoName,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS Value,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			  \#(_filtersWithHost)
			  AND SrcPort IN (
						    SELECT SrcPort
						    FROM flows_raw
						    WHERE $__timeFilter(TimeReceived)
						    \#(_filtersWithHost)
						    GROUP BY SrcPort
						    ORDER BY sum(Bytes * SamplingRate) DESC
						    LIMIT 10
			  )
			GROUP BY time, Proto, SrcPort, FlowDirection
			ORDER BY time
			"""#

	"Top 10 Destination Ports":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    toString(DstPort) AS DstPortStr,
			    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS ProtoName,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS Value,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE
			  $__timeFilter(TimeReceived)
			  \#(_filtersWithHost)
			  AND DstPort IN (
						    SELECT DstPort
						    FROM flows_raw
						    WHERE $__timeFilter(TimeReceived)
			          \#(_filtersWithHost)
						    GROUP BY DstPort
						    ORDER BY sum(Bytes * SamplingRate) DESC
						    LIMIT 10
			  )
			GROUP BY time, Proto, DstPort, FlowDirection
			ORDER BY time
			"""#
}

_trafficDetails: [{
	title: "Traffic Details (expensive)"
	gridPos: y: 93
	type: "row"
}, {
	title: "TCP Flags"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 94}
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.TCPFlagsName} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficDetailQueries[title]
	}]
}, {
	title: "VLAN ID"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 94}
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.Vlan} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficDetailQueries[title]
	}]
}, {
	title: "Top 10 Source Ports"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 106}
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.ProtoName}, ${__field.labels.SrcPortStr} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficDetailQueries[title]
	}]
}, {
	title: "Top 10 Destination Ports"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 106}
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.ProtoName}, ${__field.labels.DstPortStr} ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _trafficDetailQueries[title]
	}]
}]

_topHostQueries: {
	"Top 10 Source IPs":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    if($showHostnames, HostToString(SamplerAddress, SrcAddr), IPv6ToString(SrcAddr)) AS Src,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS BitsPerSecond,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			  \#(_filters)
			  AND SrcAddr IN (
						    SELECT SrcAddr
						    FROM flows_raw
						    WHERE $__timeFilter(TimeReceived)
			          \#(_filters)
						    GROUP BY SrcAddr
						    ORDER BY sum(Bytes * SamplingRate) DESC
						    LIMIT 10
			  )
			GROUP BY time, SamplerAddress, SrcAddr, FlowDirection
			ORDER BY time
			"""#

	"Top 10 Destination IPs":
		#"""
			SELECT
			    $__timeInterval(TimeReceived) as time,
			    if($showHostnames, HostToString(SamplerAddress, DstAddr), IPv6ToString(DstAddr)) AS Dst,
			    (sum(Bytes * SamplingRate) * 8 / $__interval_s) AS BitsPerSecond,
			    if(isIncomingFlow(FlowDirection, SrcAddr, DstAddr), 'in', 'out') AS FlowDirectionStr
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			  \#(_filters)
			  AND DstAddr IN (
						    SELECT DstAddr
						    FROM flows_raw
						    WHERE $__timeFilter(TimeReceived)
						    \#(_filters)
						    GROUP BY DstAddr
						    ORDER BY sum(Bytes * SamplingRate) DESC
						    LIMIT 10
			  )
			GROUP BY time, SamplerAddress, DstAddr, FlowDirection
			ORDER BY time
			"""#

	"Top 100 Source IPs":
		#"""
			SELECT
			    if($showHostnames, SamplerToString(SamplerAddress), IPv6ToString(SamplerAddress)) as Sampler,
			    if($showHostnames, HostToString(SamplerAddress, SrcAddr), IPv6ToString(SrcAddr)) AS Src,
			    sum(Bytes * SamplingRate) as Bytes
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filters)
			AND Proto = 6
			AND $__conditionalAll((DstAddr = toIPv6('$hostIP')), $hostIP)
			GROUP BY SamplerAddress, SrcAddr
			ORDER BY Bytes DESC
			LIMIT 100
			"""#
	"Top 100 Destination IPs":
		#"""
			SELECT
			    if($showHostnames, SamplerToString(SamplerAddress), IPv6ToString(SamplerAddress)) as Sampler,
			    if($showHostnames, HostToString(SamplerAddress, DstAddr), IPv6ToString(DstAddr)) AS Dst,
			    sum(Bytes * SamplingRate) as Bytes
			FROM flows_raw
			WHERE $__timeFilter(TimeReceived)
			\#(_filters)
			AND Proto = 6
			AND $__conditionalAll((SrcAddr = toIPv6('$hostIP')), $hostIP)
			GROUP BY SamplerAddress, DstAddr
			ORDER BY Bytes DESC
			LIMIT 100
			"""#
}

_topHosts: [{
	title: "Top Hosts (expensive)"
	gridPos: y: 107
	type: "row"
}, {
	title: "Top 10 Source IPs"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 0, y: 108}
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.Src}, ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _topHostQueries[title]
	}]
}, {
	title: "Top 10 Destination IPs"
	type:  "timeseries"
	gridPos: {h: 12, w: 12, x: 12, y: 108}
	fieldConfig: defaults: unit:        "bps"
	fieldConfig: defaults: displayName: "${__field.labels.Dst}, ${__field.labels.FlowDirectionStr}"
	targets: [{
		rawSql: _topHostQueries[title]
	}]
}, {
	title: "Top 100 Source IPs"
	type:  "table"
	gridPos: {h: 12, w: 12, x: 0, y: 120}
	fieldConfig: defaults: unit: "bytes"
	fieldConfig: overrides: [{
		matcher: {
			id:      "byName"
			options: "Bytes"
		}
		properties: [{
			id:    "custom.displayMode"
			value: "gradient-gauge"
		}]
	}]
	targets: [{
		rawSql: _topHostQueries[title]
	}]
}, {
	title: "Top 100 Destination IPs"
	type:  "table"
	gridPos: {h: 12, w: 12, x: 12, y: 120}
	fieldConfig: defaults: unit: "bytes"
	fieldConfig: overrides: [{
		matcher: {
			id:      "byName"
			options: "Bytes"
		}
		properties: [{
			id:    "custom.displayMode"
			value: "gradient-gauge"
		}]
	}]
	targets: [{
		rawSql: _topHostQueries[title]
	}]
}]

_topFlowQueries: "Top 100 Flows":
	#"""
		SELECT
		    if($showHostnames, SamplerToString(SamplerAddress), IPv6ToString(SamplerAddress)) as Sampler,
		    if($showHostnames, HostToString(SamplerAddress, SrcAddr), IPv6ToString(SrcAddr)) AS Src,
		    if($showHostnames, HostToString(SamplerAddress, DstAddr), IPv6ToString(DstAddr)) AS Dst,
		    toString(SrcPort) AS SrcPortStr,
		    toString(DstPort) AS DstPortStr,
		    dictGetString('IPProtocols', 'Name', toUInt64(Proto)) AS ProtoName,
		    sum(Bytes * SamplingRate) as Bytes
		FROM flows_raw
		    WHERE $__timeFilter(TimeReceived)
		    \#(_filtersWithHost)
		GROUP BY SamplerAddress, SrcAddr, DstAddr, SrcPort, DstPort, Proto
		ORDER BY Bytes DESC
		LIMIT 100
		"""#

_topFlows: [{
	title: "Top Flows (expensive)"
	gridPos: y: 121
	type: "row"
}, {
	title: "Top 100 Flows"
	type:  "table"
	gridPos: {h: 12, w: 24, x: 0, y: 122}
	fieldConfig: overrides: [{
		matcher: {
			id:      "byName"
			options: "Bytes"
		}
		properties: [{
			id:    "custom.displayMode"
			value: "gradient-gauge"
		}, {
			id:    "unit"
			value: "bytes"
		}]
	}]
	targets: [{
		rawSql: _topFlowQueries[title]
	}]
}]

_heatmapQueries: {
	"IP TTL":
		#"""
			select time,
			       Keys,
			       Values
			from (WITH ([toUInt8(0)], [toUInt64(0)]) AS emptyTuple
			      select time,
			             arrayMax(groupArray(Count))                                                       as Max,
			             mapAdd((groupArray(Value), groupArray(Count)), emptyTuple)                        as Data,
			             tupleElement(Data, 1)                                                             as Keys,
			             arrayMap((v) -> toUInt8(v / Max * 128), tupleElement(Data, 2))                    as Values
			      from (SELECT DISTINCT $__timeInterval(TimeReceived) as time,
			                            toUInt8(IPTTL)                                                  as Value,
			                            toUInt64(count())                                               as Count
			            from flows_raw
			            WHERE $__timeFilter(TimeReceived)
			            \#(_filtersWithHost)
			            GROUP BY time, IPTTL
			            ORDER BY time, IPTTL
			          )
			      group by time
			      order by time) ARRAY JOIN Keys, Values;
			"""#
	"Packet Size (Bytes)":
		#"""
			select time,
			       Keys,
			       Values
			from (WITH ([toUInt32(0)], [toUInt64(0)]) AS emptyTuple
			      select time,
			             arrayMax(groupArray(Count))                                                       as Max,
			             mapAdd((groupArray(Value), groupArray(Count)), emptyTuple)                        as Data,
			             tupleElement(Data, 1)                                                             as Keys,
			             arrayMap((v) -> toUInt8(v / Max * 128), tupleElement(Data, 2))                    as Values
			      from (SELECT DISTINCT $__timeInterval(TimeReceived) as time,
			                            toUInt32(Bytes)                                                 as Value,
			                            toUInt64(count())                                               as Count
			            from flows_raw
			            WHERE $__timeFilter(TimeReceived)
			            \#(_filtersWithHost)
			            GROUP BY time, Bytes
			            ORDER BY time, Bytes
			          )
			      group by time
			      order by time) ARRAY JOIN Keys, Values;
			"""#
	"Source Port":
		#"""
			select time,
			       Keys,
			       Values
			from (WITH ([toUInt16(0)], [toUInt64(0)]) AS emptyTuple
			      select time,
			             arrayMax(groupArray(Count))                                                       as Max,
			             mapAdd((groupArray(Value), groupArray(Count)), emptyTuple)                        as Data,
			             tupleElement(Data, 1)                                                             as Keys,
			             arrayMap((v) -> toUInt8(v / Max * 128), tupleElement(Data, 2))                    as Values
			      from (SELECT DISTINCT $__timeInterval(TimeReceived) as time,
			                            toUInt16(SrcPort)                                               as Value,
			                            toUInt64(count())                                               as Count
			            from flows_raw
			            WHERE $__timeFilter(TimeReceived)
			            \#(_filtersWithHost)
			            GROUP BY time, SrcPort
			            ORDER BY time, SrcPort
			          )
			      group by time
			      order by time) ARRAY JOIN Keys, Values;
			"""#
	"Destination Port":
		#"""
			select time,
			       Keys,
			       Values
			from (WITH ([toUInt16(0)], [toUInt64(0)]) AS emptyTuple
			      select time,
			             arrayMax(groupArray(Count))                                                       as Max,
			             mapAdd((groupArray(Value), groupArray(Count)), emptyTuple)                        as Data,
			             tupleElement(Data, 1)                                                             as Keys,
			             arrayMap((v) -> toUInt8(v / Max * 128), tupleElement(Data, 2))                    as Values
			      from (SELECT DISTINCT $__timeInterval(TimeReceived) as time,
			                            toUInt16(DstPort)                                               as Value,
			                            toUInt64(count())                                               as Count
			            from flows_raw
			            WHERE $__timeFilter(TimeReceived)
			            \#(_filtersWithHost)
			            GROUP BY time, DstPort
			            ORDER BY time, DstPort
			          )
			      group by time
			      order by time) ARRAY JOIN Keys, Values;
			"""#
}

_heatmaps: [{
	title: "Heatmaps (may induce spontaneous browser combustion)"
	gridPos: y: 134
	type: "row"
}, {
	title: "IP TTL"
	type:  "heatmap"
	gridPos: {h: 12, w: 12, x: 0, y: 135}
	options: calculation: xBuckets: mode:  "count"
	options: calculation: xBuckets: value: 150
	options: calculation: yBuckets: mode:  "size"
	options: calculation: yBuckets: value: 1
	options: yAxis: {max: 255, min: 0, unit: "short"}
	options: color: max: 128
	targets: [{
		rawSql: _heatmapQueries[title]
	}]
}, {
	title: "Packet Size (Bytes)"
	type:  "heatmap"
	gridPos: {h: 12, w: 12, x: 12, y: 135}
	options: calculation: xBuckets: mode:  "count"
	options: calculation: xBuckets: value: 150
	options: calculation: yBuckets: mode:  "size"
	options: calculation: yBuckets: value: 10
	options: yAxis: {max: 1500, min: 0, unit: "bytes"}
	options: color: max: 128
	targets: [{
		rawSql: _heatmapQueries[title]
	}]
}, {
	title: "Source Port"
	type:  "heatmap"
	gridPos: {h: 12, w: 12, x: 0, y: 147}
	options: calculation: xBuckets: mode:  "count"
	options: calculation: xBuckets: value: 150
	options: calculation: yBuckets: mode:  "size"
	options: calculation: yBuckets: value: 1000
	options: yAxis: {max: 65535, min: 0, unit: "short"}
	options: color: max: 128
	targets: [{
		rawSql: _heatmapQueries[title]
	}]
}, {
	title: "Destination Port"
	type:  "heatmap"
	gridPos: {h: 12, w: 12, x: 12, y: 147}
	options: calculation: xBuckets: mode:  "count"
	options: calculation: xBuckets: value: 150
	options: calculation: yBuckets: mode:  "size"
	options: calculation: yBuckets: value: 1000
	options: yAxis: {max: 65535, min: 0, unit: "short"}
	options: color: max: 128
	targets: [{
		rawSql: _heatmapQueries[title]
	}]
}]

dashboards: Overview: {
	#folder: "NetMeta"
	title:   "Overview"
	uid:     "9Dw5dGzGk"
	_panels: _disclaimerPanels +
		_infoPanels +
		_trafficStatistics +
		_originASStatistics +
		_trafficDetails +
		_topHosts +
		_topFlows +
		_heatmaps
}
