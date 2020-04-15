package k8s

NetMetaConfig :: {
	// Size of the goflow sFlow/IPFIX ingestion queue. Keeping
	// a larger queue allows for backprocessing of longer periods of historical data.
	goflowTopicRetention: *1_000_000_000 | int // GB

	// Kubernetes namespace
	namespace: *"default" | string

	// ClickHouse write credentials
	clickhousePassword: string
}
