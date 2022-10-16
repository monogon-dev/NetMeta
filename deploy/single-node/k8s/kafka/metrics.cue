package kafka

Kafka: "netmeta": spec: {
	kafkaExporter: {
		topicRegex: ".*"
		groupRegex: ".*"
	}
	metrics: {
		// Inspired by config from Kafka 2.0.0 example rules:
		// https://github.com/prometheus/jmx_exporter/blob/master/example_configs/kafka-2_0_0.yml
		lowercaseOutputName: true
		rules: [{
			// Special cases and very specific rules
			pattern: "kafka.server<type=(.+), name=(.+), clientId=(.+), topic=(.+), partition=(.*)><>Value"
			name:    "kafka_server_$1_$2"
			type:    "GAUGE"
			labels: {
				clientId:  "$3"
				topic:     "$4"
				partition: "$5"
			}
		}, {
			pattern: "kafka.server<type=(.+), name=(.+), clientId=(.+), brokerHost=(.+), brokerPort=(.+)><>Value"
			name:    "kafka_server_$1_$2"
			type:    "GAUGE"
			labels: {
				clientId: "$3"
				broker:   "$4:$5"
			}
		}, {
			// Some percent metrics use MeanRate attribute
			// Ex) kafka.server<type=(KafkaRequestHandlerPool), name=(RequestHandlerAvgIdlePercent)><>MeanRate
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)Percent\\w*><>MeanRate"
			name:    "kafka_$1_$2_$3_percent"
			type:    "GAUGE"
		}, {
			// Generic gauges for percents
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)Percent\\w*><>Value"
			name:    "kafka_$1_$2_$3_percent"
			type:    "GAUGE"
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)Percent\\w*, (.+)=(.+)><>Value"
			name:    "kafka_$1_$2_$3_percent"
			type:    "GAUGE"
			labels: $4: "$5"
		}, {
			// Generic per-second counters with 0-2 key/value pairs
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)PerSec\\w*, (.+)=(.+), (.+)=(.+)><>Count"
			name:    "kafka_$1_$2_$3_total"
			type:    "COUNTER"
			labels: {
				$4: "$5"
				$6: "$7"
			}
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)PerSec\\w*, (.+)=(.+)><>Count"
			name:    "kafka_$1_$2_$3_total"
			type:    "COUNTER"
			labels: $4: "$5"
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)PerSec\\w*><>Count"
			name:    "kafka_$1_$2_$3_total"
			type:    "COUNTER"
		}, {
			// Generic gauges with 0-2 key/value pairs
			pattern: "kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Value"
			name:    "kafka_$1_$2_$3"
			type:    "GAUGE"
			labels: {
				$4: "$5"
				$6: "$7"
			}
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+)><>Value"
			name:    "kafka_$1_$2_$3"
			type:    "GAUGE"
			labels: $4: "$5"
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)><>Value"
			name:    "kafka_$1_$2_$3"
			type:    "GAUGE"
		}, {
			// Emulate Prometheus 'Summary' metrics for the exported 'Histogram's.
			// Note that these are missing the '_sum' metric!
			pattern: "kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Count"
			name:    "kafka_$1_$2_$3_count"
			type:    "COUNTER"
			labels: {
				$4: "$5"
				$6: "$7"
			}
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.*), (.+)=(.+)><>(\\d+)thPercentile"
			name:    "kafka_$1_$2_$3"
			type:    "GAUGE"
			labels: {
				$4:       "$5"
				$6:       "$7"
				quantile: "0.$8"
			}
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+)><>Count"
			name:    "kafka_$1_$2_$3_count"
			type:    "COUNTER"
			labels: $4: "$5"
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.*)><>(\\d+)thPercentile"
			name:    "kafka_$1_$2_$3"
			type:    "GAUGE"
			labels: {
				$4:       "$5"
				quantile: "0.$6"
			}
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)><>Count"
			name:    "kafka_$1_$2_$3_count"
			type:    "COUNTER"
		}, {
			pattern: "kafka.(\\w+)<type=(.+), name=(.+)><>(\\d+)thPercentile"
			name:    "kafka_$1_$2_$3"
			type:    "GAUGE"
			labels: quantile: "0.$4"
		}]
	}
}
