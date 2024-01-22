package clickhouse

import (
	"netmeta.monogon.tech/xml"
)

files: "risinfo.conf": (xml.#Marshal & {in: yandex: dictionary: {
	name: "risinfo"
	source: http: {
		url:    "\(#Config.risinfoURL)/rib.tsv"
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
}}).out

files: "autnums.conf": (xml.#Marshal & {in: yandex: dictionary: {
	name: "autnums"
	source: clickhouse: query:
		#"""
			SELECT * FROM dictionaries.risinfo_autnums
			UNION ALL
			SELECT * FROM dictionaries.user_autnums
			"""#
	lifetime: 3600
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
}}).out

files: "risinfo_autnums.conf": (xml.#Marshal & {in: yandex: dictionary: {
	name: "risinfo_autnums"
	source: http: {
		url:    "\(#Config.risinfoURL)/autnums.tsv"
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
}}).out

files: "format_function.xml": (xml.#Marshal & {in: yandex: functions: {
	type:        "executable"
	name:        "formatQuery"
	return_type: "String"
	argument: [{
		type: "String"
		name: "query"
	}]
	format:         "LineAsString"
	command:        "clickhouse format --oneline"
	execute_direct: "0"
}}).out
