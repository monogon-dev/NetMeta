package k8s

k8s: services: risinfo: spec: {
	ports: [{
		name:       "risinfo"
		protocol:   "TCP"
		port:       80
		targetPort: "api"
	}]
	selector: app: "risinfo"
}

k8s: pvcs: "risinfo-cache": {}

k8s: deployments: risinfo: {
	M=metadata: labels: app: "risinfo"

	spec: {
		selector: matchLabels: app: M.labels.app
		template: {
			metadata: labels: app: M.labels.app

			spec: {
				containers: [
					{
						name:            "risinfo"
						imagePullPolicy: "Never"
						image:           netmeta.images.risinfo

						args: ["-cacheDir=/cache"]

						ports: [
							{name: "api", containerPort: 8080, protocol: "TCP"},
						]

						volumeMounts: [{mountPath: "/cache", name: "risinfo-cache"}]
					},
				]

				volumes: [{name: "risinfo-cache", persistentVolumeClaim: claimName: name}]
			}
		}
	}
}
