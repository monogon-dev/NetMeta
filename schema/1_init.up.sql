-- See FlowMessage.proto for documentation.

CREATE TABLE IF NOT EXISTS flows_queue
(
    FlowType         UInt8,

    SequenceNum     UInt64,

    TimeReceived     UInt64,
    SamplingRate     UInt64,

    FlowDirection    UInt8,

    SamplerAddress   IPv6,

    TimeFlowStart    UInt64,
    TimeFlowEnd      UInt64,

    Bytes            UInt64,
    Packets          UInt64,

    SrcAddr          IPv6,
    DstAddr          IPv6,

    EType            UInt16,

    Proto            UInt8,

    SrcPort          UInt32,
    DstPort          UInt32,

    InIf             UInt32,
    OutIf            UInt32,

    SrcMac           UInt64,
    DstMac           UInt64,

    SrcVlan          UInt32,
    DstVlan          UInt32,
    VlanId           UInt32,

    IngressVrfId     UInt32,
    EgressVrfId      UInt32,

    IPTos            UInt8,
    ForwardingStatus UInt8,
    IPTTL            UInt8,
    TCPFlags         UInt8,
    IcmpType         UInt8,
    IcmpCode         UInt8,
    IPv6FlowLabel    UInt32,

    FragmentId       UInt32,
    FragmentOffset   UInt32,

    BiFlowDirection  UInt8,

    SrcAS            UInt32,
    DstAS            UInt32,

    NextHop          IPv6,
    NextHopAS        UInt32,

    SrcNet           UInt8,
    DstNet           UInt8

    -- Skipping encapsulation data
    -- Skipping MPLS data
    -- Skipping PPP data

) ENGINE = Kafka()
      SETTINGS
          kafka_broker_list = 'netmeta-kafka-bootstrap:9092',
          kafka_topic_list = 'flow-messages',
          kafka_group_name = 'clickhouse',
          kafka_format = 'Protobuf',
          kafka_schema = './FlowMessage.proto:FlowMessage',
          kafka_max_block_size = 1048576;

CREATE TABLE IF NOT EXISTS flows_raw
(
    -- Generated Date field for partitioning
    Date             Date,

    -- Raw fields

    FlowType         Enum8(
        'FLOWUNKNOWN' = 0,
        'SFLOW_5' = 1,
        'NETFLOW_V5' = 2,
        'NETFLOW_V9' = 3,
        'IPFIX' = 4
        ),

    SequenceNum     UInt64,

    TimeReceived     UInt64,
    SamplingRate     UInt64,

    FlowDirection    UInt8,

    SamplerAddress   IPv6,

    TimeFlowStart    UInt64,
    TimeFlowEnd      UInt64,

    Bytes            UInt64,
    Packets          UInt64,

    SrcAddr          IPv6,
    DstAddr          IPv6,

    EType            UInt16,

    Proto            UInt8,

    SrcPort          UInt32,
    DstPort          UInt32,

    InIf             UInt32,
    OutIf            UInt32,

    SrcMac           UInt64,
    DstMac           UInt64,

    SrcVlan          UInt32,
    DstVlan          UInt32,
    VlanId           UInt32,

    IngressVrfId     UInt32,
    EgressVrfId      UInt32,

    IPTos            UInt8,
    ForwardingStatus UInt8,
    IPTTL            UInt8,
    TCPFlags         UInt8,
    IcmpType         UInt8,
    IcmpCode         UInt8,
    IPv6FlowLabel    UInt32,

    FragmentId       UInt32,
    FragmentOffset   UInt32,

    BiFlowDirection  UInt8,

    SrcAS            UInt32,
    DstAS            UInt32,

    NextHop          IPv6,
    NextHopAS        UInt32,

    SrcNet           UInt8,
    DstNet           UInt8
) ENGINE = MergeTree()
      PARTITION BY Date
      ORDER BY (TimeReceived, FlowDirection, SamplerAddress, SrcAS, DstAS, SrcAddr, DstAddr)
      TTL Date + INTERVAL 1 MONTH;

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
       *
FROM flows_queue;
