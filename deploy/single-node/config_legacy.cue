package k8s

#InterfaceMap: {
	// Router source address (IPv6 or pseudo-IPv4 mapped address like ::100.0.0.1, and for the portmirror ::ffff:100.0.0.1)
	device: string
	// Numeric interface Index (often known as the "SNMP ID")
	idx: uint
	// Human-readable interface description to show in the frontend
	description: string
}

// deprecated config parameter
#LegacyNetMetaConfig: {
	// List of router interfaces to resolve to names
	interfaceMap: [...#InterfaceMap]
}

#InterfaceMapConverter: {
	IN=in: [...#InterfaceMap]
	out: #SamplerConfig

	out: {
		for i in IN {
			"\(i.device)": interface: "\(i.idx)": description: "\(i.description)"
		}
	}
}

// A small test to verify that the #InterfaceMapConverter converts the structs correctly
_interfaceMapConverterTest: #InterfaceMapConverter & {
	in: [
		{device: "::100.0.0.1", idx: 858, description:  "TRANSIT-ABC"},
		{device: "::100.0.0.1", idx: 1126, description: "PEERING-YOLO-COLO"},
	]

	out: close({
		"::100.0.0.1": {
			interface: "858": description:  "TRANSIT-ABC"
			interface: "1126": description: "PEERING-YOLO-COLO"
		}
	})
}

// set all interfaces that are defined in the old interfaceMap in the new schema
netmeta: config: sampler: (#InterfaceMapConverter & {in: netmeta.config.interfaceMap}).out
