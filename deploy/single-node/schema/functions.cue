package schema

import "strings"

import "list"

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

function: isIncomingFlow: {
	arguments: ["SamplerAddress", "SrcAddr", "DstAddr", "SrcAS", "DstAS", "FlowDirection"]

	#ColumnExpression: {
		_function_column_handler: {
			SamplerAddressInRange: "isIPAddressInRange(toString(SamplerAddress, toIPv6Net('\(_strValue)'))"
			SrcAddrInRange:        "isIPAddressInRange(toString(SrcAddr, toIPv6Net('\(_strValue)'))"
			DstAddrInRange:        "isIPAddressInRange(toString(DstAddr, toIPv6Net('\(_strValue)'))"
		}
		_function_columns: [ for k, _ in _function_column_handler {k}]

		_valid:    true & (list.Contains(arguments, column) | list.Contains(_function_columns, column))
		column:    string
		value:     string | int
		_strValue: "\(value)"

		#out: string | *"toString(\(column)) == '\(_strValue)'"

		// if the value is an int, we can skip toString
		if (value & int) != _|_ {
			#out: "\(column) == \(_strValue)"
		}

		// if it is a special handler
		if list.Contains(_function_columns, column) {
			#out: _function_column_handler[column]
		}
	}

	#SamplerExpression: {
		sampler: string
		expressions: [...string]
		#out: """
		if(
			toString(SamplerAddress) == '\(sampler)',
			\(strings.Join(expressions, " OR ")),
			NULL
		)
		"""
	}

	// dear reader I am very sorry for this monstrosity, but when I used a pretty version with placeholders,
	// CUE just stackoverflowed. I hope that with a future version this can be pretty again, but for now
	// we have to live with it.
	_expressions: [
		for device, cfg in #Config.sampler if len(cfg.isIncomingFlow) != 0 {

			// join the column expressions together
			(#SamplerExpression & {
				sampler: device
				_valid: true & len(expressions) > 0

				expressions: [ for e in cfg.isIncomingFlow if len(e) != 0 {
					// for each instance create the column expressions and join them by AND
					_expressions: [ for c, v in e {

						// create the sql expression for this column
						(#ColumnExpression & {
							column: c
							value:  v
						}).#out
					}]

					"( " + strings.Join(_expressions, " AND ") + " )"
				}]
			}).#out
		},

		// Fallback to FlowDirection == 0
		"FlowDirection == 0",
	]

	query: "coalesce( \(strings.Join(_expressions, ",\n")) )"
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
		  startsWith(reinterpret(Address, 'FixedString(16)'), repeat('\x00', 10) || repeat('\xff', 2)),
		  IPv4NumToString(CAST(reinterpret(reverse(substring(reinterpret(Address, 'FixedString(16)'), 13, 16)), 'UInt32') AS IPv4)),
		  IPv6NumToString(Address)
		)
		"""#
}

function: ParseGoFlowAddress: {
	arguments: ["Address"]
	query: #"""
		if(
		  -- endsWith IPv6v4NullPadding
		  endsWith(reinterpret(Address, 'FixedString(16)'), repeat('\x00', 12)),
		  -- prepend ::ffff:
		  CAST(toFixedString(repeat('\x00', 10) || repeat('\xff', 2) || substr(reinterpret(Address, 'FixedString(16)'), 1, 4), 16) AS IPv6),
		  Address
		)
		"""#
}

function: switchEndian: {
	arguments: ["s"]
	query:
		#"""
			unhex(
				arrayStringConcat(
					arrayMap(x -> substring(hex(s), x, 2), reverse(range(1, length(s) * 2, 2)))
				)
			)
			"""#
}

function: ParseFastNetMonAddress: {
	arguments: ["Address"]
	query: #"""
		if(
		  length(Address) == 4,
		  IPv4ToIPv6(CAST(reinterpret(switchEndian(Address), 'UInt32') AS IPv4)),
		  CAST(toFixedString(Address, 16) AS IPv6)
		)
		"""#
}

// Wrapper for returning the ColumnIndex of a table
// currently required to select a field inside a SamplerAddress, SrcAddr, DstAddr, SrcAS, DstAS, FlowDirection
// see isIncomingFlow for usage
function: ColumnIndex: {
	arguments: ["Database", "Table", "Column"]
	query: #"""
		(SELECT position from system.columns where database = Database and table = Table and name = Column)
		"""#
}
