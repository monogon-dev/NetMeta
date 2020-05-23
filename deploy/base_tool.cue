package k8s

objects: [ x for v in objectSets for x in v ]

objectSets: [
  // Regular stuff
	k8s.crds,
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
]
