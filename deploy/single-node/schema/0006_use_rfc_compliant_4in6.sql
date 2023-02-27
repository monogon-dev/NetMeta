-- +goose Up
-- First delete the view
DROP VIEW IF EXISTS flows_raw_view;

CREATE FUNCTION ParseAddress AS(Address) -> if(
    -- endsWith IPv6v4NullPadding
        endsWith(reinterpret(Address, 'FixedString(16)'), repeat('\x00', 12)),
    -- prepend ::ffff:
        reinterpret(toFixedString(repeat('\x00', 10) || repeat('\xff', 2) || substr(Address, 1, 4), 16), 'IPv6'),
        Address
    );

CREATE MATERIALIZED VIEW flows_raw_view TO flows_raw
AS
SELECT toDate(TimeReceived) AS Date,
       * REPLACE (
    ParseAddress(SamplerAddress) AS SamplerAddress,
    ParseAddress(SrcAddr) AS SrcAddr,
    ParseAddress(DstAddr) AS DstAddr,
    if(NextHop != toFixedString('', 16), ParseAddress(NextHop), NextHop) AS NextHop,
    if(SrcAS == 0, dictGetUInt32('risinfo', 'asnum', SrcAddr), SrcAS) as SrcAS,
    if(DstAS == 0, dictGetUInt32('risinfo', 'asnum', DstAddr), DstAS) as DstAS,
    coalesce(dictGet('SamplerConfig', 'SamplingRate', IPv6NumToString(SamplerAddress)), SamplingRate) as SamplingRate
    )
FROM flows_queue;

-- +goose Down
DROP VIEW IF EXISTS flows_raw_view;

DROP FUNCTION ParseAddress;

-- This is the same query as `0004_add_sampling_rate_override.sql`
CREATE MATERIALIZED VIEW  flows_raw_view TO flows_raw
AS
WITH
    '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' AS IPv6v4NullPadding,
    '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00' AS IPv6Null
SELECT toDate(TimeReceived) AS Date,
       *
        REPLACE(
            if(endsWith(SamplerAddress, IPv6v4NullPadding),
               reinterpret(toFixedString(IPv6v4NullPadding || substr(SamplerAddress, 1, 4), 16), 'IPv6'), SamplerAddress) AS SamplerAddress,
            if(endsWith(SrcAddr, IPv6v4NullPadding),
               reinterpret(toFixedString(IPv6v4NullPadding || substr(SrcAddr, 1, 4), 16), 'IPv6'), SrcAddr) AS SrcAddr,
            if(endsWith(DstAddr, IPv6v4NullPadding),
               reinterpret(toFixedString(IPv6v4NullPadding || substr(DstAddr, 1, 4), 16), 'IPv6'), DstAddr) AS DstAddr,
            if(endsWith(NextHop, IPv6v4NullPadding) and NextHop != IPv6Null,
               reinterpret(toFixedString(IPv6v4NullPadding || substr(NextHop, 1, 4), 16), 'IPv6'), NextHop) AS NextHop,
            if(SrcAS == 0, dictGetUInt32('risinfo', 'asnum', tuple(reinterpretAsFixedString(SrcAddr))), SrcAS) as SrcAS,
            if(DstAS == 0, dictGetUInt32('risinfo', 'asnum', tuple(reinterpretAsFixedString(DstAddr))), DstAS) as DstAS,
            coalesce(dictGet('SamplerConfig', 'SamplingRate', IPv6NumToString(SamplerAddress)), SamplingRate) as SamplingRate
            )
FROM flows_queue;