-- +goose Up

-- goflow stores IP addresses as raw bytes without indicating the protocol.
-- Normalize them to IPv6 addresses that ClickHouse understands (null prefix rather than suffix).
--
-- Not sure about performance of this conversion step - might be better to do it in goflow.
CREATE MATERIALIZED VIEW IF NOT EXISTS flows_raw_view TO flows_raw
AS
WITH
    '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' AS IPv6v4NullPadding,
    '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' AS IPv6Null
SELECT toDate(TimeReceived) AS Date,
       if(endsWith(SamplerAddress, IPv6v4NullPadding),
          CAST(toFixedString(IPv6v4NullPadding || substr(SamplerAddress, 1, 4), 16) AS IPv6), SamplerAddress) AS SamplerAddress,
       if(endsWith(SrcAddr, IPv6v4NullPadding),
          CAST(toFixedString(IPv6v4NullPadding || substr(SrcAddr, 1, 4), 16) AS IPv6), SrcAddr) AS SrcAddr,
       if(endsWith(DstAddr, IPv6v4NullPadding),
          CAST(toFixedString(IPv6v4NullPadding || substr(DstAddr, 1, 4), 16) AS IPv6), DstAddr) AS DstAddr,
       if(endsWith(NextHop, IPv6v4NullPadding) and NextHop != IPv6Null,
          CAST(toFixedString(IPv6v4NullPadding || substr(NextHop, 1, 4), 16) AS IPv6), NextHop) AS NextHop,
       if(SrcAS == 0, dictGetUInt32('risinfo', 'asnum', tuple(reinterpretAsFixedString(SrcAddr))), SrcAS) as SrcAS,
       if(DstAS == 0, dictGetUInt32('risinfo', 'asnum', tuple(reinterpretAsFixedString(DstAddr))), DstAS) as DstAS,
       *
FROM flows_queue;


-- +goose Down
DROP VIEW IF EXISTS flows_raw_view;