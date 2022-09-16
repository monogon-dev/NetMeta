package netmeta

#Config: {
	// Minimum interval for all panels
	interval: string | null

	// Maximum packet size for heatmaps (filter out spurious oversized packet from loopback interfaces)
	maxPacketSize: uint | *1500
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

_datasource: "NetMeta ClickHouse"

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
	}]
}
