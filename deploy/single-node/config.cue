package k8s

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

#InterfaceMap: {
	// Router source address (IPv6 or pseudo-IPv4 mapped address like ::100.0.0.1)
	device: string
	// Numeric interface Index (often known as the "SNMP ID")
	idx: uint
	// Human-readable interface description to show in the frontend
	description: string
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

#PortMirrorConfig: {
	// The Interfaces to listen to. Multiple interface pairs can be set by seperating them with a comma.
	interfaces: string | *"tap_rx:tap_tx"

	// The sample rate for the traffic sniffing. Defaults to every 1000th frame.
	sampleRate: int | *1000
}

#NetMetaConfig: {
	// Size of the goflow sFlow/IPFIX ingestion queue. Keeping
	// a larger queue allows for backprocessing of longer periods of historical data.
	goflowTopicRetention: *1_000_000_000 | int // GB

	// Kubernetes namespace
	namespace: *"default" | string

	// ClickHouse write credentials
	clickhouseOperatorPassword: string

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

	// List of router interfaces to resolve to names
	interfaceMap: [...#InterfaceMap]

	// Expose the ClickHouse HTTP query API on the port defined above.
	enableClickhouseIngress: bool | *false

	// When set to a PortMirrorConfig, the PortMirror Tool will be deployed and
	// listen to the defined interfaces.
	portMirror?: #PortMirrorConfig

	// Defines if the goflow tool should be deployed
	deployGoflow: bool | *true
}

#Image: string

#NetMetaImages: {
	helloworld: #Image
	risinfo:    #Image
	goflow:     #Image
	portmirror: #Image
}
