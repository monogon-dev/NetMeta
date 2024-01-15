package risinfo

#Config: {
	digest: string
	image:  string
}

Service: risinfo: spec: {
	ports: [{
		name:       "risinfo"
		protocol:   "TCP"
		port:       80
		targetPort: "api"
	}]
	selector: Deployment["risinfo"].spec.selector.matchLabels
}

PersistentVolumeClaim: "risinfo-cache": {}

Deployment: risinfo: {
	M=metadata: labels: app: "risinfo"

	spec: {
		selector: matchLabels: app: M.labels.app
		template: {
			metadata: labels: app: M.labels.app

			// Trigger redeployment when digest changes.
			metadata: annotations: "meta/local-image-digest": #Config.digest

			spec: containers: [{
				name:            "risinfo"
				imagePullPolicy: "Never"
				image:           #Config.image
				args: ["-cacheDir=/cache"]
				ports: [{
					name:          "api"
					containerPort: 8080
					protocol:      "TCP"
				}]

				volumeMounts: [{
					mountPath: "/cache"
					name:      "risinfo-cache"
				}]},
			]

			spec: volumes: [{
				name: "risinfo-cache"
				persistentVolumeClaim: claimName: "risinfo-cache"
			}]
		}
	}
}
