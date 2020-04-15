package k8s

k8s: clickhouseinstallations: netmeta: spec: {
	defaults: templates: {
		dataVolumeClaimTemplate: "local-pv"
		logVolumeClaimTemplate:  "local-pv"
	}
	configuration: clusters: [
		{
			name: "netmeta"
			templates: {}
			zookeeper: {}
			address: {}
			layout: {
				shardsCount:   1
				replicasCount: 1
			}
		},
	]
	templates: volumeClaimTemplates: [{
		name:          "local-pv"
		reclaimPolicy: ""
		spec: {
			accessModes: [
				"ReadWriteOnce",
			]
			dataSource: null
			resources: requests: storage: "100Gi"
		}
	}]
}
