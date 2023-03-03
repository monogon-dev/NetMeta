package schema

function: HostToString: {
	arguments: ["Sampler", "Host"]
	query: "dictGetStringOrDefault('HostNames', 'Description', (IPv6NumToString(Sampler), Host), IPv6ToString(Host))"
}

function: SamplerToString: {
	arguments: ["Sampler"]
	query: "dictGetStringOrDefault('SamplerConfig', 'Description', IPv6NumToString(Sampler), Sampler)"
}

function: ASNToString: {
	arguments: ["ASN"]
	query: "substring(dictGetString('autnums', 'name', toUInt64(ASN)), 1, 25) || ' AS' || toString(ASN)"
}

function: VLANToString: {
	arguments: ["Sampler", "VLAN"]
	query: "dictGetStringOrDefault('VlanNames', 'Description', (IPv6NumToString(Sampler), VLAN), VLAN)"
}

function: InterfaceToString: {
	arguments: ["Sampler", "Interface"]
	query: #"""
		if(
		  isNull(dictGetOrNull('InterfaceNames', 'Description', (IPv6NumToString(Sampler), Interface))),
		  SamplerToString(Sampler) || ' - ' || toString(Interface),
		  SamplerToString(Sampler) || ' - ' || toString(Interface) || ' [' ||
		  dictGetString('InterfaceNames', 'Description', (IPv6NumToString(Sampler), Interface)) || ']'
		)
		"""#
}

// create the function with Src/DstAddr params, to resolve unknown FlowDirections in the future
function: isIncomingFlow: {
	arguments: ["FlowDirection", "SrcAddr", "DstAddr"]
	query: "FlowDirection == 0"
}

function: toIPv6Net: {
	arguments: ["Net"]
	query: #"""
		if(
		  isIPv4String(splitByChar('/', Net)[1]),
		  '::ffff:' || arrayStringConcat(
		    arrayMap((v, i) -> if(i, toString(toInt8(v) + 96), v), splitByChar('/', Net), [false, true]),
		    '/'),
		  Net
		)
		"""#
}

function: IPv6ToString: {
	arguments: ["Address"]
	query: #"""
		if(
		  startsWith(Address, repeat('\x00', 10) || repeat('\xff', 2)),
		  IPv4NumToString(reinterpret(reverse(substring(Address, 13, 16)), 'IPv4')),
		  IPv6NumToString(Address)
		)
		"""#
}

function: ParseAddress: {
	arguments: ["Address"]
	query: #"""
		if(
		  -- endsWith IPv6v4NullPadding
		  endsWith(reinterpret(Address, 'FixedString(16)'), repeat('\x00', 12)),
		  -- prepend ::ffff:
		  reinterpret(toFixedString(repeat('\x00', 10) || repeat('\xff', 2) || substr(Address, 1, 4), 16), 'IPv6'),
		  Address
		);
		"""#
}
