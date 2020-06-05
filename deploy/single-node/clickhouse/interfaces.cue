package k8s

import (
	"strings"
)

let config = netmeta.config

k8s: clickhouseinstallations: netmeta: spec: configuration: files: {
	// Dictionary for user-defined interface name lookup

	_interfaceMap: [ for e in config.interfaceMap {strings.Join([
		e.device, "\(e.idx)", e.description,
	], "\t")
	}]

	"InterfaceNames.dict": #"""
    <yandex>
        <dictionary>
            <name>InterfaceNames</name>
            <source>
                <file>
                    <path>/etc/clickhouse-server/config.d/InterfaceNames.tsv</path>
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
                    <name>Description</name>
                    <type>String</type>
                    <null_value />
                </attribute>
            </structure>
        </dictionary>
    </yandex>
    """#

	"InterfaceNames.tsv": strings.Join(_interfaceMap, "\n")
}
