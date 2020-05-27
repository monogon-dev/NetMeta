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

#NetMetaConfig: {
	// Size of the goflow sFlow/IPFIX ingestion queue. Keeping
	// a larger queue allows for backprocessing of longer periods of historical data.
	goflowTopicRetention: *1_000_000_000 | int // GB

	// Kubernetes namespace
	namespace: *"default" | string

	// ClickHouse write credentials
	clickhouseOperatorPassword: string

	// Let's Encrypt Mode
	//  - off: self-signed certificate
	//  - staging: staging Let's Encrypt server (recommended for testing!)
	//  - production: production Let's Encrypt server (beware of rate limits)
	//
	// Switching between staging and production will not automatically
	// delete the existing certificate - delete acme.json and restart Traefik.
	letsencryptMode: "off" | *"staging" | "production"

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
	grafanaGoogleAuth: #GoogleAuth
}

#NetMetaImages: {
	helloworld: string
	migrate:    string
}
