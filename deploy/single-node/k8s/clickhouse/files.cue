package clickhouse

import (
	"strings"
	"netmeta.monogon.tech/xml"
)

// template for TSV dictionaries
_files: [NAME=string]: {
	cfg: {
		layout:    _
		structure: _
	}
	data: _

	_cfg: yandex: dictionary: {
		cfg

		name: NAME
		source: [{
			file: {
				path:   "/etc/clickhouse-server/config.d/\(NAME).tsv"
				format: "TSV"
			}
			settings: format_tsv_null_representation: "NULL"
		}]
		lifetime: 60
	}
}

// Iterate over all defined files in _files and generate the config files for clickhouse
ClickHouseInstallation: netmeta: spec: configuration: files: {
	for k, v in _files {
		"\(k).conf": (xml.#Marshal & {in: v._cfg}).out
		"\(k).tsv":  v.data
	}
}

// Dictionary for user-defined interface name lookup
_files: InterfaceNames: {
	data: strings.Join([ for s in #Config.sampler for i in s.interface {
		strings.Join([s.device, "\(i.id)", i.description], "\t")
	}], "\n")

	cfg: {
		layout: complex_key_hashed: null
		structure: {
			key: [{
				attribute: {
					name: "Device"
					type: "String"
				}
			}, {
				attribute: {
					name: "Index"
					type: "UInt32"
				}
			}]
			attribute: {
				name:       "Description"
				type:       "String"
				null_value: null
			}
		}
	}
}

// Dictionary for user-defined sampler settings lookup
_files: SamplerConfig: {
	data: strings.Join([ for s in #Config.sampler {
		let samplingRate = [
			if s.samplingRate == 0 {
				"NULL"
			},
			"\(s.samplingRate)",
		][0]

		let description = [
			if s.description == "" {
				"NULL"
			},
			"\(s.description)",
		][0]

		strings.Join([s.device, samplingRate, description], "\t")
	}], "\n")

	cfg: {
		layout: complex_key_hashed: null
		structure: {
			key: [{
				attribute: {
					name: "Device"
					type: "String"
				}
			}]
			attribute: {
				name:       "SamplingRate"
				type:       "Nullable(UInt64)"
				null_value: null
			}
		}
	}
}

// Dictionary for user-defined vlan name lookup
_files: VlanNames: {
	data: strings.Join([ for s in #Config.sampler for v in s.vlan {
		strings.Join([s.device, "\(v.id)", v.description], "\t")
	}], "\n")

	cfg: {
		layout: complex_key_hashed: null
		structure: {
			key: [{
				attribute: {
					name: "Device"
					type: "String"
				}
			}, {
				attribute: {
					name: "Index"
					type: "UInt32"
				}
			}]
			attribute: {
				name:       "Description"
				type:       "String"
				null_value: null
			}
		}
	}
}

// Dictionary for user-defined host name lookup
_files: HostNames: {
	data: strings.Join([ for s in #Config.sampler for h in s.host {
		strings.Join([s.device, h.device, h.description], "\t")
	}], "\n")

	cfg: {
		layout: complex_key_hashed: null
		structure: {
			key: [{
				attribute: {
					name: "Sampler"
					type: "String"
				}
			}, {
				attribute: {
					name: "Device"
					type: "String"
				}
			}]
			attribute: {
				name:       "Description"
				type:       "String"
				null_value: null
			}
		}
	}
}

ClickHouseInstallation: netmeta: spec: configuration: files: "risinfo.conf": (xml.#Marshal & {in: {
	yandex: dictionary: {
		name: "risinfo"
		source: http: {
			url:    "http://risinfo/rib.tsv"
			format: "TabSeparated"
		}
		lifetime: 3600
		layout: ip_trie: access_to_key_from_attributes: true
		structure: key: attribute: {
			name: "prefix"
			type: "String"
		}
		structure: attribute: {
			name:       "asnum"
			type:       "UInt32"
			null_value: 0
		}
	}
}}).out

ClickHouseInstallation: netmeta: spec: configuration: files: "autnums.conf": (xml.#Marshal & {in: {
	yandex: dictionary: {
		name: "autnums"
		source: http: {
			url:    "http://risinfo/autnums.tsv"
			format: "TabSeparated"
		}
		lifetime: 86400
		layout: flat: null
		structure: [{
			id: name: "asnum"
		}, {
			attribute: {
				name:       "name"
				type:       "String"
				null_value: null
			}
		}, {
			attribute: {
				name:       "country"
				type:       "String"
				null_value: null
			}
		}]
	}
}}).out
