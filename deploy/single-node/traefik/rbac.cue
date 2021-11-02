package k8s

k8s: clusterroles: "traefik-ingress-controller": rules: [{
	apiGroups: [
		"",
	]
	resources: [
		"services",
		"endpoints",
		"secrets",
	]
	verbs: [
		"get",
		"list",
		"watch",
	]
}, {
	apiGroups: [
		"extensions",
	]
	resources: [
		"ingresses",
	]
	verbs: [
		"get",
		"list",
		"watch",
	]
}, {
	apiGroups: [
		"extensions",
	]
	resources: [
		"ingresses/status",
	]
	verbs: [
		"update",
	]
}, {
	apiGroups: [
		"traefik.containo.us",
	]
	resources: [
		"middlewares",
		"ingressroutes",
		"traefikservices",
		"ingressroutetcps",
		"ingressrouteudps",
		"tlsoptions",
		"tlsstores",
		"serverstransports",
		"middlewaretcps",
	]
	verbs: [
		"get",
		"list",
		"watch",
	]
}]

k8s: clusterrolebindings: "traefik-ingress-controller": {
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "traefik-ingress-controller"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      "traefik-ingress-controller"
		namespace: "default"
	}]
}
