package schema

table: flows_queue: {
	schema: "FlowMessage.proto:FlowMessage"
	engine: "Kafka"
	settings: kafka_broker_list:    "netmeta-kafka-bootstrap:9092"
	settings: kafka_topic_list:     "flow-messages"
	settings: kafka_group_name:     "clickhouse"
	settings: kafka_format:         "Protobuf"
	settings: kafka_schema:         schema
	settings: kafka_max_block_size: int & 1048576
}

if #Config.fastNetMon != _|_ {
	table: fastnetmon_queue: {
		schema: "traffic_data.proto:TrafficData"
		engine: "Kafka"
		settings: kafka_broker_list:    "netmeta-kafka-bootstrap:9092"
		settings: kafka_topic_list:     "fastnetmon"
		settings: kafka_group_name:     "clickhouse"
		settings: kafka_format:         "ProtobufSingle"
		settings: kafka_schema:         schema
		settings: kafka_max_block_size: int & 1048576
	}
}
