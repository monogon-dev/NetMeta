package nix

import (
	"net"
	"strconv"
)

#DashboardDisplayConfig: {
	// Minimum interval for all panels. By default, there's no minimum interval and the interval goes all the way down
	// to minimum resolution (1s). For IPFIX, the minimum flow export interval may be a large multiple of that,
	// resulting in misleading rendering when zooming in (spikes at multiples of the flow export resolution).
	//
	// For IPFIX, set minInterval to 2× the minimum flow timeout on the network device.
	minInterval: string | null | *null

	// Maximum packet size for heatmap panel. We set a fixed maximum value to filter out spurious oversizes packets from
	// loopback interfaces and have the right scale when only small packets are visible.
	maxPacketSize: *1500 | uint

	// The config for the FastNetMon integration
	fastNetMon: *null | {
		// Name of a FastNetMon InfluxDB datasource. If you use NetMeta alongside FastNetMon, attack
		// notifications can be shown in NetMeta. You have to manually create the FastNetMon
		// datasource and connect it to your instance.
		dataSource: string | *"FastNetMon InfluxDB"
	}
}

// IPv6 or pseudo-IPv4 mapped address like ::ffff:100.0.0.1
#DeviceAddress: string & net.IP & !~"^:?:?[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$"

// A small test to verify that #DeviceAddress forbids the old IP mapping
_deviceAddressTest: {
	IN=in: {
		// Key is the value to test
		// Value is the parsing result
		"2001:0DB8::1":     true
		"::ffff:127.0.0.1": true
		"::ffff:127.0.0.1": true
		"::127.0.0.1":      false
		"127.0.0.1":        false
	}

	out: {
		for k, v in IN {
			"\(k)": v
			"\(k)": (k & #DeviceAddress) != _|_
		}
	}
}

// for COLUMN you can use the following columns:
// SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection
// additionally it is possible to use these with a valid CIDR
// SamplerAddressInRange, SrcAddrInRange, DstAddrInRange
#ColumnExpression: [COLUMN=string]: string | int

// A struct containing sampler specific config parameters
#SamplerConfig: [DEVICE=string]: {
	// Router source address
	device: DEVICE & #DeviceAddress

	// Sampling rate to override the sampling rate provided by the sampler
	samplingRate: int | *0

	// Human-readable host description to show in the frontend
	description: string | *""

	// anonymize the last 8byte for v6 addresses and 1byte for v4 addresses
	anonymizeAddresses: bool | *false

	// how to detect an incoming flow
	// each array entry is connected by an OR statement
	// everything inside a #ColumnExpression is connected with AND
	isIncomingFlow: [...#ColumnExpression]

	// Interface names for the data from this sampler
	interface: [ID=string]: {
		// Numeric interface Index (often known as the "SNMP ID")
		id: *strconv.Atoi(ID) | int

		// Human-readable interface description to show in the frontend
		description: string
	}

	vlan: [ID=string]: {
		// Numeric VLAN ID
		id: *strconv.Atoi(ID) | int

		// Human-readable vlan description to show in the frontend
		description: string
	}

	// Host names for the data from this sampler
	host: [DEVICE=string]: {
		// Host source address
		device: DEVICE & #DeviceAddress

		// Human-readable host description to show in the frontend
		description: string
	}
}

#UserData: {
	// Custom ASNs
	autnums: [ASN=string]: {
		asn:     *strconv.Atoi(ASN) | int
		name:    string
		country: string
	}
}

#NixConfig: {
	// Base url to access risinfo
	risinfoURL:      string | *"http://localhost:14680"

	// Base path of clickhouse dictionary data
	dataPath:        string | *"/etc/clickhouse-server/config.d"

	// comma seperated list of kafka brokers
	kafkaBrokerList: string | *"localhost:9092"
}

#NetMetaConfig: {
	// Dashboard display config - these settings only affect rendering of the Grafana dashboards.
	dashboardDisplay: #DashboardDisplayConfig

	// Config parameter like interface names. See #SamplerConfig
	sampler: #SamplerConfig

	// Userprovided data like custom ASNs
	userData: #UserData

	deployment: nix: #NixConfig
}
