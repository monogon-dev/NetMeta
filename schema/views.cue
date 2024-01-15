package schema

view: flows_raw_view: {
	from: "flows_queue"
	to:   "flows_raw"
	query:
	// language=clickhouse
	#"""
		SELECT * REPLACE (
		    if(
		            dictGet('SamplerConfig', 'AnonymizeAddresses', IPv6NumToString(SamplerAddress)),
		            toIPv6(cutIPv6(SrcAddr, 8, 1)),
		            SrcAddr
		        ) AS SrcAddr,
		    if(
		            dictGet('SamplerConfig', 'AnonymizeAddresses', IPv6NumToString(SamplerAddress)),
		            toIPv6(cutIPv6(DstAddr, 8, 1)),
		            DstAddr
		        ) AS DstAddr
		    )
		FROM (
		         SELECT toDate(TimeReceived) AS Date,
		                * REPLACE (
		             ParseGoFlowAddress(SamplerAddress) AS SamplerAddress,
		             ParseGoFlowAddress(SrcAddr) AS SrcAddr,
		             ParseGoFlowAddress(DstAddr) AS DstAddr,
		             if(
		                         NextHop != toFixedString('', 16),
		                         ParseGoFlowAddress(NextHop),
		                         toIPv6('::')
		                 ) AS NextHop,
		             if(
		                         SrcAS == 0,
		                         dictGetUInt32('risinfo', 'asnum', SrcAddr),
		                         SrcAS
		                 ) as SrcAS,
		             if(
		                         DstAS == 0,
		                         dictGetUInt32('risinfo', 'asnum', DstAddr),
		                         DstAS
		                 ) as DstAS,
		             coalesce(
		                     dictGet('SamplerConfig', 'SamplingRate', IPv6NumToString(SamplerAddress)),
		                     SamplingRate
		                 ) as SamplingRate
		             )
		         FROM %%from%%
		         )
		"""#
}

if #Config.fastNetMon != _|_ {
	view: fastnetmon_view: {
		from: "fastnetmon_queue"
		to:   "flows_raw"
		query:
			// language=clickhouse
			#"""
				SELECT * REPLACE(
				               if(
				                           SrcAS == 0,
				                           dictGetUInt32('risinfo', 'asnum', SrcAddr),
				                           SrcAS
				                   ) as SrcAS,
				               if(
				                           DstAS == 0,
				                           dictGetUInt32('risinfo', 'asnum', DstAddr),
				                           DstAS
				                   ) as DstAS,
				               if(
				                       dictGet('SamplerConfig', 'AnonymizeAddresses', IPv6NumToString(SamplerAddress)),
				                       toIPv6(cutIPv6(SrcAddr, 8, 1)),
				                       SrcAddr
				                   ) AS SrcAddr,
				               if(
				                       dictGet('SamplerConfig', 'AnonymizeAddresses', IPv6NumToString(SamplerAddress)),
				                       toIPv6(cutIPv6(SrcAddr, 8, 1)),
				                       DstAddr
				                   ) AS DstAddr
				           )
				FROM (
				         SELECT toDate(timestamp_seconds)                   as Date,
				                0                                           as FlowType,
				                timestamp_seconds                           as TimeReceived,
				                sampling_ratio                              as SamplingRate,
				                traffic_direction                           as FlowDirection,
				                ParseFastNetMonAddress(agent_address)       AS SamplerAddress,
				                octets                                      as Bytes,
				                packets                                     as Packets,
				                ParseFastNetMonAddress(source_ip)           AS SrcAddr,
				                ParseFastNetMonAddress(destination_ip)      AS DstAddr,
				                protocol                                    as Proto,
				                source_port                                 as SrcPort,
				                destination_port                            as DstPort,
				                input_interface                             as InIf,
				                output_interface                            as OutIf,
				                ttl                                         as IPTTL,
				                tcp_flags                                   as TCPFlags,
				                source_asn                                  as SrcAS,
				                destination_asn                             as DstAS
				         FROM %%from%%
				         )
				"""#
	}
}
