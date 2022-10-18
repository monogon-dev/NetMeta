-- +goose Up
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

-- +goose Down
DROP TABLE IF EXISTS flows_queue;