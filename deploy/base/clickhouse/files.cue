package clickhouse

import (
	"strings"
	"strconv"
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
				path:   "\(#Config.dataPath)/\(NAME).tsv"
				format: "TSV"
			}
			settings: format_tsv_null_representation: "NULL"
		}]
		lifetime: 60
	}
}

// Dictionary for user-defined interface name lookup
_files: InterfaceNames: {
	data: strings.Join([for s in #Config.sampler for i in s.interface {
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
	data: strings.Join([for s in #Config.sampler {
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

		strings.Join([s.device, samplingRate, description, strconv.FormatBool(s.anonymizeAddresses)], "\t")
	}], "\n")

	cfg: {
		layout: complex_key_hashed: null
		structure: [{
			key: [{
				attribute: {
					name: "Device"
					type: "String"
				}
			}]
		}, {
			attribute: {
				name:       "SamplingRate"
				type:       "Nullable(UInt64)"
				null_value: null
			}
		}, {
			attribute: {
				name:       "Description"
				type:       "Nullable(String)"
				null_value: null
			}
		}, {
			attribute: {
				name:       "AnonymizeAddresses"
				type:       "Bool"
				null_value: false
			}
		}]
	}
}

// Dictionary for user-defined vlan name lookup
_files: VlanNames: {
	data: strings.Join([for s in #Config.sampler for v in s.vlan {
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
	data: strings.Join([for s in #Config.sampler for h in s.host {
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

_files: user_autnums: {
	data: strings.Join([for _, e in #Config.userData.autnums {
		strings.Join(["\(e.asn)", e.name, e.country], "\t")
	}], "\n")

	cfg: {
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
}
