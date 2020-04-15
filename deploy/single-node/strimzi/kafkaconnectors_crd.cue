package k8s

k8s: crds: "kafkaconnectors.kafka.strimzi.io": spec: {
	group: "kafka.strimzi.io"
	versions: [{
		name:    "v1alpha1"
		served:  true
		storage: true
	}]
	version: "v1alpha1"
	scope:   "Namespaced"
	names: {
		kind:     "KafkaConnector"
		listKind: "KafkaConnectorList"
		singular: "kafkaconnector"
		plural:   "kafkaconnectors"
		shortNames: [
			"kctr",
		]
		categories: [
			"strimzi",
		]
	}
	subresources: status: {}
	validation: openAPIV3Schema: properties: {
		spec: {
			type: "object"
			properties: {
				class: type: "string"
				tasksMax: {
					type:    "integer"
					minimum: 1
				}
				config: type: "object"
				pause: type:  "boolean"
			}
		}
		status: {
			type: "object"
			properties: {
				conditions: {
					type: "array"
					items: {
						type: "object"
						properties: {
							type: type:               "string"
							status: type:             "string"
							lastTransitionTime: type: "string"
							reason: type:             "string"
							message: type:            "string"
						}
					}
				}
				observedGeneration: type: "integer"
				connectorStatus: type:    "object"
			}
		}
	}
}
