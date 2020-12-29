package k8s

objects: [ for v in objectSets for x in v {x}]

objectSets: [
	// Regular stuff
	k8s.clusterrolebindings,
	k8s.clusterroles,
	k8s.rolebindings,
	k8s.serviceaccounts,
	k8s.deployments,
	k8s.services,
	k8s.configmaps,
	k8s.statefulsets,
	k8s.pvcs,

	// CRDs
	k8s.kafkas,
	k8s.kafkatopics,
	k8s.clickhouseinstallations,
	k8s.ingressroutes,
	k8s.ingressrouteudps,
]

// Prerequisite objects to apply first, in a separate kubectl call.
preObjects: [ for v in [
	k8s.crds,
] for x in v {x}]
