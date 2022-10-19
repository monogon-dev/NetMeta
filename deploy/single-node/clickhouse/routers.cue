package k8s

import (
	"strings"
)

let config = netmeta.config

k8s: clickhouseinstallations: netmeta: spec: configuration: files: {
	// Dictionary for user-defined interface name lookup

	_routerMap: [ for e in config.routerMap {strings.Join([
		e.device, "\(e.idx)", e.name,
	], "\t")
	}]

	"Router.dict": #"""
    <yandex>
        <dictionary>
            <name>Router</name>
            <source>
                <file>
                    <path>/etc/clickhouse-server/config.d/Router.tsv</path>
                    <format>TSV</format>
                </file>
            </source>
            <lifetime>60</lifetime>
            <layout><complex_key_hashed/></layout>
            <structure>
                <key>
                    <attribute>
                        <name>Device</name>
                        <type>String</type>
                    </attribute>
                    <attribute>
                        <name>Index</name>
                        <type>UInt32</type>
                    </attribute>
                </key>
                <attribute>
                    <name>Name</name>
                    <type>String</type>
                    <null_value />
                </attribute>
            </structure>
        </dictionary>
    </yandex>
    """#

	"Router.tsv": strings.Join(_routerMap, "\n")
}
