package k8s

import (
	"net"
	"strconv"
)

#GoogleAuth: {
	// Get credentials at https://console.cloud.google.com/apis/credentials
	// See https://grafana.com/docs/grafana/latest/auth/google for instructions.
	clientID:     string
	clientSecret: string

	// List of GSuite domains that may sign in.
	allowedDomains: [string, ...string]

	// Allow any user that can authenticate to sign up?
	allowSignup: bool | *true
}

#Ports: {
	// Frontend (HTTP is redirected to HTTPS)
	http:       int | *80
	https:      int | *443
	clickhouse: int | *8123

	// Netflow/IPFIX
	netflow: int | *2055
	// NetFlow V5
	netflowLegacy: int | *2056
	// sFlow
	sflow: int | *6343
}

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
}

// The config for the FastNetMon integration
#FastNetMonConfig: {
	// Name of a FastNetMon InfluxDB datasource. If you use NetMeta alongside FastNetMon, attack
	// notifications can be shown in NetMeta. You have to manually create the FastNetMon
	// datasource and connect it to your instance.
	dataSource: string | *"FastNetMon InfluxDB"
}

#PortMirrorConfig: {
	// The address the instance use as SamplerAddress
	samplerAddress: #DeviceAddress | *"::ffff:127.0.0.1"

	// The Interfaces to listen to. Multiple interface pairs can be set by seperating them with a comma.
	interfaces: string | *"tap_rx:tap_tx"

	// The sample rate for the traffic sniffing. Defaults to every 1000th frame.
	sampleRate: int | *1000
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

// A struct containing sampler specific config parameters
#SamplerConfig: [DEVICE=string]: {
	// Router source address
	device: DEVICE & #DeviceAddress

	// Sampling rate to override the sampling rate provided by the sampler
	samplingRate: int | *0

	// Human-readable host description to show in the frontend
	description: string | *""

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

#NetMetaConfig: {
	// Allow the use of legacy config parameters
	#LegacyNetMetaConfig

	// Size of the goflow sFlow/IPFIX ingestion queue. Keeping
	// a larger queue allows for backprocessing of longer periods of historical data.
	goflowTopicRetention: *1_000_000_000 | int // GB

	// Kubernetes namespace
	namespace: *"default" | string

	// ClickHouse write credentials
	clickhouseAdminPassword: string

	// Session secret for Prometheus and Grafana
	sessionSecret: string

	// External ports
	ports: #Ports

	// Dashboard display config - these settings only affect rendering of the Grafana dashboards.
	dashboardDisplay: #DashboardDisplayConfig

	// Let's Encrypt Mode
	//  - off: self-signed certificate (TODO, right now, it just disables certificates altogether)
	//  - staging: staging Let's Encrypt server (recommended for testing!)
	//  - production: production Let's Encrypt server (beware of rate limits)
	//
	// Switching between staging and production will not automatically
	// delete the existing certificate - delete acme.json and restart Traefik.
	letsencryptMode: *"staging" | "production" | "off"

	// Let's Encrypt Account Email Address
	letsencryptAccountMail: string

	// Public hostname
	publicHostname: string

	// Initial Grafana admin password
	// (after the first deployment, it can only be changed within Grafana)
	grafanaInitialAdminPassword: string

	// Enable Grafana basic authentication (you might to disable it after setting up third-party auth).
	// OAuth auto login will be enabled if you disable basic auth.
	//
	// Note that the built-in admin user can authenticate even if basic auth is disabled.
	grafanaBasicAuth: bool | *true

	// Optional: configure GSuite authentication
	grafanaGoogleAuth?: #GoogleAuth

	// Default org role for new Grafana users
	grafanaDefaultRole: string | *"Viewer"

	// Expose the ClickHouse HTTP query API on the port defined above.
	enableClickhouseIngress: bool | *false

	// Expose Kafka on a Nodeport
	enableExternalKafkaListener: bool | *false

	// The URL to advertise to hosts connecting over the external Kafka listener
	advertisedKafkaHost: string | *"127.0.0.1"

	// When set to a PortMirrorConfig, the PortMirror Tool will be deployed and
	// listen to the defined interfaces.
	portMirror?: #PortMirrorConfig

	// Defines if the goflow tool should be deployed
	deployGoflow: bool | *true

	// When set to a FastNetMonConfig, the FastNetMon integration for Grafana will be enabled
	fastNetMon?: #FastNetMonConfig

	// Config parameter like interface names. See #SamplerConfig
	sampler: #SamplerConfig
}

#Image: {
	image:  string
	digest: string
}

#NetMetaImages: {
	helloworld: #Image
	risinfo:    #Image
	goflow:     #Image
	portmirror: #Image
}
