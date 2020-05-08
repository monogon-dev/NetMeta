CREATE TABLE IF NOT EXISTS flows
(
    TimeReceived   UInt64,
    TimeFlowStart  UInt64,
    SequenceNum    UInt32,
    SamplingRate   UInt64,
    SamplerAddress FixedString(16),
    SrcAddr        FixedString(16),
    DstAddr        FixedString(16),
    SrcAS          UInt32,
    DstAS          UInt32,
    EType          UInt32,
    Proto          UInt32,
    SrcPort        UInt32,
    DstPort        UInt32,
    Bytes          UInt64,
    Packets        UInt64
) ENGINE = Kafka()
      SETTINGS
          kafka_broker_list = 'netmeta-kafka-bootstrap:9092',
          kafka_topic_list = 'flow-messages',
          kafka_group_name = 'clickhouse',
          kafka_format = 'Protobuf',
          kafka_schema = './FlowMessage.proto:FlowMessage';

CREATE TABLE IF NOT EXISTS flows_raw
(
    Date           Date,
    TimeReceived   DateTime,
    TimeFlowStart  DateTime,
    SequenceNum    UInt32,
    SamplingRate   UInt64,
    SamplerAddress FixedString(16),
    SrcAddr        FixedString(16),
    DstAddr        FixedString(16),
    SrcAS          UInt32,
    DstAS          UInt32,
    EType          UInt32,
    Proto          UInt32,
    SrcPort        UInt32,
    DstPort        UInt32,
    Bytes          UInt64,
    Packets        UInt64
) ENGINE = MergeTree()
      PARTITION BY Date
      ORDER BY TimeReceived;

CREATE MATERIALIZED VIEW IF NOT EXISTS flows_raw_view TO flows_raw
AS
SELECT toDate(TimeReceived) AS Date,
       *
FROM flows;
