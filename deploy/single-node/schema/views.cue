package schema

view: flows_raw_view: {
	from: "flows_queue"
	to:   "flows_raw"
	query: #"""
		SELECT * REPLACE (
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
		         SELECT toDate(TimeReceived) AS Date,
		                * REPLACE (
		             ParseAddress(SamplerAddress) AS SamplerAddress,
		             ParseAddress(SrcAddr) AS SrcAddr,
		             ParseAddress(DstAddr) AS DstAddr,
		             if(
		                         NextHop != toFixedString('', 16),
		                         ParseAddress(NextHop),
		                         NextHop
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
