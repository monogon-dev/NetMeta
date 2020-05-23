package k8s

k8s: crds: [Name=string]: spec: {
	group:   "traefik.containo.us"
	version: "v1alpha1"
	scope:   "Namespaced"
	names: {
		kind:     string
		singular: string
		plural:   "\(singular)s"
	}
}

k8s: crds: "ingressroutes.traefik.containo.us": spec: names: {
	kind:     "IngressRoute"
	plural:   "ingressroutes"
	singular: "ingressroute"
}

k8s: crds: "middlewares.traefik.containo.us": spec: names: {
	kind:     "Middleware"
	plural:   "middlewares"
	singular: "middleware"
}

k8s: crds: "ingressroutetcps.traefik.containo.us": spec: names: {
	kind:     "IngressRouteTCP"
	plural:   "ingressroutetcps"
	singular: "ingressroutetcp"
}

k8s: crds: "ingressrouteudps.traefik.containo.us": spec: names: {
	kind:     "IngressRouteUDP"
	plural:   "ingressrouteudps"
	singular: "ingressrouteudp"
}

k8s: crds: "tlsoptions.traefik.containo.us": spec: names: {
	kind:     "TLSOption"
	plural:   "tlsoptions"
	singular: "tlsoption"
}

k8s: crds: "tlsstores.traefik.containo.us": spec: names: {
	kind:     "TLSStore"
	plural:   "tlsstores"
	singular: "tlsstore"
}

k8s: crds: "traefikservices.traefik.containo.us": spec: names: {
	kind:     "TraefikService"
	plural:   "traefikservices"
	singular: "traefikservice"
}
