package k8s

k8s: {
	// TODO(leo): cue bug?
	crds: [Name=_]: metadata: labels: app:                      "strimzi"
	deployments: [Name=_]: metadata: labels: app:               "strimzi"
	rolebindings: [Name=_]: metadata: labels: app:              "strimzi"
	clusterrolebindings: [Name=_]: metadata: labels: app:       "strimzi"
	clusterroles: [Name=_]: metadata: labels: app:              "strimzi"
	serviceaccounts: [Name=_]: metadata: labels: app:           "strimzi"
	crds: [Name=_]: metadata: labels: "strimzi.io/crd-install": "true"
}
