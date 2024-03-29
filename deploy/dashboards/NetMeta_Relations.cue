package dashboards

_asRelationQueries: {
	"Inbound traffic relations (Top 20)":
		#"""
SELECT
  ASNToString(SrcAS) AS SrcASName,
  ASNToString(DstAS) AS DstASName,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
AND isIncomingFlow(SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection)
GROUP BY SrcAS, DstAS
ORDER BY Bytes DESC
LIMIT 20
"""#

	"Outbound traffic relations (Top 20)":
		#"""
SELECT
  ASNToString(DstAS) AS DstASName,
  ASNToString(SrcAS) AS SrcASName,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
AND NOT isIncomingFlow(SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection)
GROUP BY SrcAS, DstAS
ORDER BY Bytes DESC
LIMIT 20
"""#

	"Inbound traffic relations via interface (Top 30)":
		#"""
SELECT
  ASNToString(SrcAS) AS SrcASName,
  InterfaceToString(SamplerAddress, OutIf) AS OutIfName,
  ASNToString(DstAS) AS DstASName,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
AND isIncomingFlow(SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection)
GROUP BY SrcAS, DstAS, SamplerAddress, OutIf
ORDER BY Bytes DESC
LIMIT 30
"""#

	"Outbound traffic relations via interface (Top 30)":
		#"""
SELECT
  ASNToString(DstAS) AS DstASName,
  InterfaceToString(SamplerAddress, OutIf) AS OutIfName,
  ASNToString(SrcAS) AS SrcASName,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
AND NOT isIncomingFlow(SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection)
GROUP BY SrcAS, DstAS, SamplerAddress, OutIf
ORDER BY Bytes DESC
LIMIT 30
"""#
}

_asRelations: [{
	title: "AS Relations"
	gridPos: y: 6
	type: "row"
}, {
	title: "Inbound traffic relations (Top 20)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 0, y: 7}
	options: nodePadding: 6
	options: nodeWidth:   23
	options: iteration:   15
	targets: [{
		rawSql: _asRelationQueries[title]
	}]
}, {
	title: "Outbound traffic relations (Top 20)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 12, y: 7}
	options: nodePadding: 6
	options: nodeWidth:   23
	options: iteration:   15
	targets: [{
		rawSql: _asRelationQueries[title]
	}]
}, {
	title: "Inbound traffic relations via interface (Top 30)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 0, y: 31}
	options: nodePadding: 6
	options: nodeWidth:   23
	options: iteration:   15
	targets: [{
		rawSql: _asRelationQueries[title]
	}]
}, {
	title: "Outbound traffic relations via interface (Top 30)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 12, y: 31}
	options: nodePadding: 6
	options: nodeWidth:   23
	options: iteration:   15
	targets: [{
		rawSql: _asRelationQueries[title]
	}]
}]

_topFlowSankeyQueries: {
	"Top 30 Flows (per IP)":
		#"""
SELECT
  if($showHostnames, HostToString(SamplerAddress, SrcAddr), IPv6ToString(SrcAddr)) AS Src,
  if($showHostnames, HostToString(SamplerAddress, DstAddr), IPv6ToString(DstAddr)) AS Dst,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
GROUP BY SamplerAddress, SrcAddr, DstAddr
ORDER BY Bytes DESC
LIMIT 30
"""#

	"Top 30 Flows (per IP+Port)":
		#"""
SELECT
  if($showHostnames, HostToString(SamplerAddress, SrcAddr), IPv6ToString(SrcAddr)) || ' ' || dictGetString('IPProtocols', 'Name', toUInt64(Proto)) || toString(SrcPort) as Src,
  if($showHostnames, HostToString(SamplerAddress, DstAddr), IPv6ToString(DstAddr)) || ' ' || dictGetString('IPProtocols', 'Name', toUInt64(Proto)) ||  toString(DstPort) as Dst,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
GROUP BY SamplerAddress, SrcAddr, SrcPort, Proto, DstAddr, DstPort
ORDER BY Bytes DESC
LIMIT 30
"""#
}

_topFlowSankey: [{
	title: "AS Relations"
	gridPos: y: 32
	type: "row"
}, {
	title: "Top 30 Flows (per IP)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 0, y: 33}
	options: nodePadding: 6
	options: nodeWidth:   28
	targets: [{
		rawSql: _topFlowSankeyQueries[title]
	}]
}, {
	title: "Top 30 Flows (per IP+Port)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 12, y: 33}
	options: nodePadding: 11
	options: nodeWidth:   28
	targets: [{
		rawSql: _topFlowSankeyQueries[title]
	}]
}]

_flowsPerASNQueries: {
	"Top 30 ASN per service (inbound)":
		#"""
SELECT
  ASNToString(SrcAS) AS SrcASName,
  if($showHostnames, HostToString(SamplerAddress, DstAddr), IPv6ToString(DstAddr)) || ' ' || dictGetString('IPProtocols', 'Name', toUInt64(Proto)) || toString(DstPort) as Dst,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
AND isIncomingFlow(SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection)
GROUP BY SrcAS, SamplerAddress, DstAddr, Proto, DstPort
ORDER BY Bytes DESC
LIMIT 30
"""#

	"Top 30 ASN per service (outbound)":
		#"""
SELECT
  ASNToString(SrcAS) AS SrcASName,
  if($showHostnames, HostToString(SamplerAddress, DstAddr), IPv6ToString(DstAddr)) || ' ' || dictGetString('IPProtocols', 'Name', toUInt64(Proto)) || toString(DstPort) as Dst,
  (sum(Bytes * SamplingRate) / 1024) as Bytes
FROM flows_raw
WHERE $__timeFilter(TimeReceived)
\#(_filtersWithHost)
AND NOT isIncomingFlow(SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection)
GROUP BY SrcAS, SamplerAddress, DstAddr, Proto, DstPort
ORDER BY Bytes DESC
LIMIT 30
"""#
}

_flowsPerASN: [{
	title: "Flows per ASN"
	gridPos: y: 34
	type: "row"
}, {
	title: "Top 30 ASN per service (inbound)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 0, y: 60}
	options: nodePadding: 11
	options: nodeWidth:   28
	targets: [{
		rawSql: _flowsPerASNQueries[title]
	}]
}, {
	title: "Top 30 ASN per service (outbound)"
	type:  "netsage-sankey-panel"
	gridPos: {h: 24, w: 12, x: 12, y: 60}
	options: nodePadding: 11
	options: nodeWidth:   28
	targets: [{
		rawSql: _flowsPerASNQueries[title]
	}]
}]

dashboards: "Traffic Relations": {
	#folder: "NetMeta"
	title:   "Traffic Relations"
	uid:     "5pH2j5ank"
	_panels: _disclaimerPanels +
		_infoPanels +
		_asRelations +
		_topFlowSankey +
		_flowsPerASN
}
