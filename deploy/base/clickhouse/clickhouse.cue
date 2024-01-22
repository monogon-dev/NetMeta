package clickhouse

import (
	schema "github.com/monogon-dev/NetMeta/deploy/single-node/schema"
	"netmeta.monogon.tech/xml"
)

// A stripped down version of the #SamplerConfig found in deploy/single-node/config.cue
#SamplerConfig: [string]: {
	device:             string
	samplingRate:       int
	anonymizeAddresses: bool
	description:        string
	interface: [string]: {
		id:          int
		description: string
	}
	vlan: [string]: {
		id:          int
		description: string
	}
	host: [string]: {
		device:      string
		description: string
	}
	...
}

#UserData: autnums: [string]: {
	asn:     int
	name:    string
	country: string
}

#Config: {
	sampler:  #SamplerConfig
	userData: #UserData

	dataPath: string
	risinfoURL: string
}

files: {
	// Iterate over our required files from schema, e.g. the protobuf files
	for k, v in schema.file {
		"\(k)": v
	}

	// Iterate over all defined files in _files and generate the config files for clickhouse
	for k, v in _files {
		"\(k).conf": (xml.#Marshal & {in: v._cfg}).out
		"\(k).tsv":  v.data
	}
}
