// cuetify import from traefik-crds.yaml

package k8s

k8s: crds: {
	"ingressroutes.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "ingressroutes.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "IngressRoute"
				listKind: "IngressRouteList"
				plural:   "ingressroutes"
				singular: "ingressroute"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "IngressRoute is an Ingress CRD specification."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "IngressRouteSpec is a specification for a IngressRouteSpec resource."
							properties: {
								entryPoints: {
									items: type: "string"
									type: "array"
								}
								routes: {
									items: {
										description: "Route contains the set of routes."
										properties: {
											kind: {
												enum: ["Rule"]
												type: "string"
											}
											match: type: "string"
											middlewares: {
												items: {
													description: "MiddlewareRef is a ref to the Middleware resources."
													properties: {
														name: type:      "string"
														namespace: type: "string"
													}
													required: ["name"]
													type: "object"
												}
												type: "array"
											}
											priority: type: "integer"
											services: {
												items: {
													description: "Service defines an upstream to proxy traffic."
													properties: {
														kind: {
															enum: ["Service", "TraefikService"]
															type: "string"
														}
														name: {
															description: "Name is a reference to a Kubernetes Service object (for a load-balancer of servers), or to a TraefikService object (service load-balancer, mirroring, etc). The differentiation between the two is specified in the Kind field."
															type:        "string"
														}
														namespace: type:      "string"
														passHostHeader: type: "boolean"
														port: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															"x-kubernetes-int-or-string": true
														}
														responseForwarding: {
															description: "ResponseForwarding holds configuration for the forward of the response."
															properties: flushInterval: type: "string"
															type: "object"
														}
														scheme: type:           "string"
														serversTransport: type: "string"
														sticky: {
															description: "Sticky holds the sticky configuration."
															properties: cookie: {
																description: "Cookie holds the sticky configuration based on cookie."
																properties: {
																	httpOnly: type: "boolean"
																	name: type:     "string"
																	sameSite: type: "string"
																	secure: type:   "boolean"
																}
																type: "object"
															}
															type: "object"
														}
														strategy: type: "string"
														weight: {
															description: "Weight should only be specified when Name references a TraefikService object (and to be precise, one that embeds a Weighted Round Robin)."
															type:        "integer"
														}
													}
													required: ["name"]
													type: "object"
												}
												type: "array"
											}
										}
										required: ["kind", "match"]
										type: "object"
									}
									type: "array"
								}
								tls: {
									description: """
												TLS contains the TLS certificates configuration of the routes. To enable Let's Encrypt, use an empty TLS struct, e.g. in YAML:
												 \t tls: {} # inline format
												 \t tls: \t   secretName: # block format
												"""
									properties: {
										certResolver: type: "string"
										domains: {
											items: {
												description: "Domain holds a domain name with SANs."
												properties: {
													main: type: "string"
													sans: {
														items: type: "string"
														type: "array"
													}
												}
												type: "object"
											}
											type: "array"
										}
										options: {
											description: "Options is a reference to a TLSOption, that specifies the parameters of the TLS connection."
											properties: {
												name: type:      "string"
												namespace: type: "string"
											}
											required: ["name"]
											type: "object"
										}
										secretName: {
											description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
											type:        "string"
										}
										store: {
											description: "Store is a reference to a TLSStore, that specifies the parameters of the TLS store."
											properties: {
												name: type:      "string"
												namespace: type: "string"
											}
											required: ["name"]
											type: "object"
										}
									}
									type: "object"
								}
							}
							required: ["routes"]
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"ingressroutetcps.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "ingressroutetcps.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "IngressRouteTCP"
				listKind: "IngressRouteTCPList"
				plural:   "ingressroutetcps"
				singular: "ingressroutetcp"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "IngressRouteTCP is an Ingress CRD specification."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "IngressRouteTCPSpec is a specification for a IngressRouteTCPSpec resource."
							properties: {
								entryPoints: {
									items: type: "string"
									type: "array"
								}
								routes: {
									items: {
										description: "RouteTCP contains the set of routes."
										properties: {
											match: type: "string"
											middlewares: {
												description: "Middlewares contains references to MiddlewareTCP resources."
												items: {
													description: "ObjectReference is a generic reference to a Traefik resource."
													properties: {
														name: type:      "string"
														namespace: type: "string"
													}
													required: ["name"]
													type: "object"
												}
												type: "array"
											}
											services: {
												items: {
													description: "ServiceTCP defines an upstream to proxy traffic."
													properties: {
														name: type:      "string"
														namespace: type: "string"
														port: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															"x-kubernetes-int-or-string": true
														}
														proxyProtocol: {
															description: "ProxyProtocol holds the ProxyProtocol configuration."
															properties: version: type: "integer"
															type: "object"
														}
														terminationDelay: type: "integer"
														weight: type:           "integer"
													}
													required: ["name", "port"]
													type: "object"
												}
												type: "array"
											}
										}
										required: ["match"]
										type: "object"
									}
									type: "array"
								}
								tls: {
									description: """
												TLSTCP contains the TLS certificates configuration of the routes. To enable Let's Encrypt, use an empty TLS struct, e.g. in YAML:
												 \t tls: {} # inline format
												 \t tls: \t   secretName: # block format
												"""
									properties: {
										certResolver: type: "string"
										domains: {
											items: {
												description: "Domain holds a domain name with SANs."
												properties: {
													main: type: "string"
													sans: {
														items: type: "string"
														type: "array"
													}
												}
												type: "object"
											}
											type: "array"
										}
										options: {
											description: "Options is a reference to a TLSOption, that specifies the parameters of the TLS connection."
											properties: {
												name: type:      "string"
												namespace: type: "string"
											}
											required: ["name"]
											type: "object"
										}
										passthrough: type: "boolean"
										secretName: {
											description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
											type:        "string"
										}
										store: {
											description: "Store is a reference to a TLSStore, that specifies the parameters of the TLS store."
											properties: {
												name: type:      "string"
												namespace: type: "string"
											}
											required: ["name"]
											type: "object"
										}
									}
									type: "object"
								}
							}
							required: ["routes"]
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"ingressrouteudps.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "ingressrouteudps.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "IngressRouteUDP"
				listKind: "IngressRouteUDPList"
				plural:   "ingressrouteudps"
				singular: "ingressrouteudp"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "IngressRouteUDP is an Ingress CRD specification."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "IngressRouteUDPSpec is a specification for a IngressRouteUDPSpec resource."
							properties: {
								entryPoints: {
									items: type: "string"
									type: "array"
								}
								routes: {
									items: {
										description: "RouteUDP contains the set of routes."
										properties: services: {
											items: {
												description: "ServiceUDP defines an upstream to proxy traffic."
												properties: {
													name: type:      "string"
													namespace: type: "string"
													port: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														"x-kubernetes-int-or-string": true
													}
													weight: type: "integer"
												}
												required: ["name", "port"]
												type: "object"
											}
											type: "array"
										}
										type: "object"
									}
									type: "array"
								}
							}
							required: ["routes"]
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"middlewares.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "middlewares.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "Middleware"
				listKind: "MiddlewareList"
				plural:   "middlewares"
				singular: "middleware"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "Middleware is a specification for a Middleware resource."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "MiddlewareSpec holds the Middleware configuration."
							properties: {
								addPrefix: {
									description: "AddPrefix holds the AddPrefix configuration."
									properties: prefix: type: "string"
									type: "object"
								}
								basicAuth: {
									description: "BasicAuth holds the HTTP basic authentication configuration."
									properties: {
										headerField: type:  "string"
										realm: type:        "string"
										removeHeader: type: "boolean"
										secret: type:       "string"
									}
									type: "object"
								}
								buffering: {
									description: "Buffering holds the request/response buffering configuration."
									properties: {
										maxRequestBodyBytes: {
											format: "int64"
											type:   "integer"
										}
										maxResponseBodyBytes: {
											format: "int64"
											type:   "integer"
										}
										memRequestBodyBytes: {
											format: "int64"
											type:   "integer"
										}
										memResponseBodyBytes: {
											format: "int64"
											type:   "integer"
										}
										retryExpression: type: "string"
									}
									type: "object"
								}
								chain: {
									description: "Chain holds a chain of middlewares."
									properties: middlewares: {
										items: {
											description: "MiddlewareRef is a ref to the Middleware resources."
											properties: {
												name: type:      "string"
												namespace: type: "string"
											}
											required: ["name"]
											type: "object"
										}
										type: "array"
									}
									type: "object"
								}
								circuitBreaker: {
									description: "CircuitBreaker holds the circuit breaker configuration."
									properties: expression: type: "string"
									type: "object"
								}
								compress: {
									description: "Compress holds the compress configuration."
									properties: excludedContentTypes: {
										items: type: "string"
										type: "array"
									}
									type: "object"
								}
								contentType: {
									description: "ContentType middleware - or rather its unique `autoDetect` option - specifies whether to let the `Content-Type` header, if it has not been set by the backend, be automatically set to a value derived from the contents of the response. As a proxy, the default behavior should be to leave the header alone, regardless of what the backend did with it. However, the historic default was to always auto-detect and set the header if it was nil, and it is going to be kept that way in order to support users currently relying on it. This middleware exists to enable the correct behavior until at least the default one can be changed in a future version."
									properties: autoDetect: type: "boolean"
									type: "object"
								}
								digestAuth: {
									description: "DigestAuth holds the Digest HTTP authentication configuration."
									properties: {
										headerField: type:  "string"
										realm: type:        "string"
										removeHeader: type: "boolean"
										secret: type:       "string"
									}
									type: "object"
								}
								errors: {
									description: "ErrorPage holds the custom error page configuration."
									properties: {
										query: type: "string"
										service: {
											description: "Service defines an upstream to proxy traffic."
											properties: {
												kind: {
													enum: ["Service", "TraefikService"]
													type: "string"
												}
												name: {
													description: "Name is a reference to a Kubernetes Service object (for a load-balancer of servers), or to a TraefikService object (service load-balancer, mirroring, etc). The differentiation between the two is specified in the Kind field."
													type:        "string"
												}
												namespace: type:      "string"
												passHostHeader: type: "boolean"
												port: {
													anyOf: [{
														type: "integer"
													}, {
														type: "string"
													}]
													"x-kubernetes-int-or-string": true
												}
												responseForwarding: {
													description: "ResponseForwarding holds configuration for the forward of the response."
													properties: flushInterval: type: "string"
													type: "object"
												}
												scheme: type:           "string"
												serversTransport: type: "string"
												sticky: {
													description: "Sticky holds the sticky configuration."
													properties: cookie: {
														description: "Cookie holds the sticky configuration based on cookie."
														properties: {
															httpOnly: type: "boolean"
															name: type:     "string"
															sameSite: type: "string"
															secure: type:   "boolean"
														}
														type: "object"
													}
													type: "object"
												}
												strategy: type: "string"
												weight: {
													description: "Weight should only be specified when Name references a TraefikService object (and to be precise, one that embeds a Weighted Round Robin)."
													type:        "integer"
												}
											}
											required: ["name"]
											type: "object"
										}
										status: {
											items: type: "string"
											type: "array"
										}
									}
									type: "object"
								}
								forwardAuth: {
									description: "ForwardAuth holds the http forward authentication configuration."
									properties: {
										address: type: "string"
										authRequestHeaders: {
											items: type: "string"
											type: "array"
										}
										authResponseHeaders: {
											items: type: "string"
											type: "array"
										}
										authResponseHeadersRegex: type: "string"
										tls: {
											description: "ClientTLS holds TLS specific configurations as client."
											properties: {
												caOptional: type:         "boolean"
												caSecret: type:           "string"
												certSecret: type:         "string"
												insecureSkipVerify: type: "boolean"
											}
											type: "object"
										}
										trustForwardHeader: type: "boolean"
									}
									type: "object"
								}
								headers: {
									description: "Headers holds the custom header configuration."
									properties: {
										accessControlAllowCredentials: {
											description: "AccessControlAllowCredentials is only valid if true. false is ignored."
											type:        "boolean"
										}
										accessControlAllowHeaders: {
											description: "AccessControlAllowHeaders must be used in response to a preflight request with Access-Control-Request-Headers set."
											items: type: "string"
											type: "array"
										}
										accessControlAllowMethods: {
											description: "AccessControlAllowMethods must be used in response to a preflight request with Access-Control-Request-Method set."
											items: type: "string"
											type: "array"
										}
										accessControlAllowOriginList: {
											description: "AccessControlAllowOriginList is a list of allowable origins. Can also be a wildcard origin \"*\"."
											items: type: "string"
											type: "array"
										}
										accessControlAllowOriginListRegex: {
											description: "AccessControlAllowOriginListRegex is a list of allowable origins written following the Regular Expression syntax (https://golang.org/pkg/regexp/)."
											items: type: "string"
											type: "array"
										}
										accessControlExposeHeaders: {
											description: "AccessControlExposeHeaders sets valid headers for the response."
											items: type: "string"
											type: "array"
										}
										accessControlMaxAge: {
											description: "AccessControlMaxAge sets the time that a preflight request may be cached."
											format:      "int64"
											type:        "integer"
										}
										addVaryHeader: {
											description: "AddVaryHeader controls if the Vary header is automatically added/updated when the AccessControlAllowOriginList is set."
											type:        "boolean"
										}
										allowedHosts: {
											items: type: "string"
											type: "array"
										}
										browserXssFilter: type:        "boolean"
										contentSecurityPolicy: type:   "string"
										contentTypeNosniff: type:      "boolean"
										customBrowserXSSValue: type:   "string"
										customFrameOptionsValue: type: "string"
										customRequestHeaders: {
											additionalProperties: type: "string"
											type: "object"
										}
										customResponseHeaders: {
											additionalProperties: type: "string"
											type: "object"
										}
										featurePolicy: {
											description: "Deprecated: use PermissionsPolicy instead."
											type:        "string"
										}
										forceSTSHeader: type: "boolean"
										frameDeny: type:      "boolean"
										hostsProxyHeaders: {
											items: type: "string"
											type: "array"
										}
										isDevelopment: type:     "boolean"
										permissionsPolicy: type: "string"
										publicKey: type:         "string"
										referrerPolicy: type:    "string"
										sslForceHost: {
											description: "Deprecated: use RedirectRegex instead."
											type:        "boolean"
										}
										sslHost: {
											description: "Deprecated: use RedirectRegex instead."
											type:        "string"
										}
										sslProxyHeaders: {
											additionalProperties: type: "string"
											type: "object"
										}
										sslRedirect: {
											description: "Deprecated: use EntryPoint redirection or RedirectScheme instead."
											type:        "boolean"
										}
										sslTemporaryRedirect: {
											description: "Deprecated: use EntryPoint redirection or RedirectScheme instead."
											type:        "boolean"
										}
										stsIncludeSubdomains: type: "boolean"
										stsPreload: type:           "boolean"
										stsSeconds: {
											format: "int64"
											type:   "integer"
										}
									}
									type: "object"
								}
								inFlightReq: {
									description: "InFlightReq limits the number of requests being processed and served concurrently."
									properties: {
										amount: {
											format: "int64"
											type:   "integer"
										}
										sourceCriterion: {
											description: "SourceCriterion defines what criterion is used to group requests as originating from a common source. If none are set, the default is to use the request's remote address field. All fields are mutually exclusive."
											properties: {
												ipStrategy: {
													description: "IPStrategy holds the ip strategy configuration."
													properties: {
														depth: type: "integer"
														excludedIPs: {
															items: type: "string"
															type: "array"
														}
													}
													type: "object"
												}
												requestHeaderName: type: "string"
												requestHost: type:       "boolean"
											}
											type: "object"
										}
									}
									type: "object"
								}
								ipWhiteList: {
									description: "IPWhiteList holds the ip white list configuration."
									properties: {
										ipStrategy: {
											description: "IPStrategy holds the ip strategy configuration."
											properties: {
												depth: type: "integer"
												excludedIPs: {
													items: type: "string"
													type: "array"
												}
											}
											type: "object"
										}
										sourceRange: {
											items: type: "string"
											type: "array"
										}
									}
									type: "object"
								}
								passTLSClientCert: {
									description: "PassTLSClientCert holds the TLS client cert headers configuration."
									properties: {
										info: {
											description: "TLSClientCertificateInfo holds the client TLS certificate info configuration."
											properties: {
												issuer: {
													description: "TLSClientCertificateDNInfo holds the client TLS certificate distinguished name info configuration. cf https://tools.ietf.org/html/rfc3739"
													properties: {
														commonName: type:      "boolean"
														country: type:         "boolean"
														domainComponent: type: "boolean"
														locality: type:        "boolean"
														organization: type:    "boolean"
														province: type:        "boolean"
														serialNumber: type:    "boolean"
													}
													type: "object"
												}
												notAfter: type:     "boolean"
												notBefore: type:    "boolean"
												sans: type:         "boolean"
												serialNumber: type: "boolean"
												subject: {
													description: "TLSClientCertificateDNInfo holds the client TLS certificate distinguished name info configuration. cf https://tools.ietf.org/html/rfc3739"
													properties: {
														commonName: type:      "boolean"
														country: type:         "boolean"
														domainComponent: type: "boolean"
														locality: type:        "boolean"
														organization: type:    "boolean"
														province: type:        "boolean"
														serialNumber: type:    "boolean"
													}
													type: "object"
												}
											}
											type: "object"
										}
										pem: type: "boolean"
									}
									type: "object"
								}
								plugin: {
									additionalProperties: "x-kubernetes-preserve-unknown-fields": true
									type: "object"
								}
								rateLimit: {
									description: "RateLimit holds the rate limiting configuration for a given router."
									properties: {
										average: {
											format: "int64"
											type:   "integer"
										}
										burst: {
											format: "int64"
											type:   "integer"
										}
										period: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											"x-kubernetes-int-or-string": true
										}
										sourceCriterion: {
											description: "SourceCriterion defines what criterion is used to group requests as originating from a common source. If none are set, the default is to use the request's remote address field. All fields are mutually exclusive."
											properties: {
												ipStrategy: {
													description: "IPStrategy holds the ip strategy configuration."
													properties: {
														depth: type: "integer"
														excludedIPs: {
															items: type: "string"
															type: "array"
														}
													}
													type: "object"
												}
												requestHeaderName: type: "string"
												requestHost: type:       "boolean"
											}
											type: "object"
										}
									}
									type: "object"
								}
								redirectRegex: {
									description: "RedirectRegex holds the redirection configuration."
									properties: {
										permanent: type:   "boolean"
										regex: type:       "string"
										replacement: type: "string"
									}
									type: "object"
								}
								redirectScheme: {
									description: "RedirectScheme holds the scheme redirection configuration."
									properties: {
										permanent: type: "boolean"
										port: type:      "string"
										scheme: type:    "string"
									}
									type: "object"
								}
								replacePath: {
									description: "ReplacePath holds the ReplacePath configuration."
									properties: path: type: "string"
									type: "object"
								}
								replacePathRegex: {
									description: "ReplacePathRegex holds the ReplacePathRegex configuration."
									properties: {
										regex: type:       "string"
										replacement: type: "string"
									}
									type: "object"
								}
								retry: {
									description: "Retry holds the retry configuration."
									properties: {
										attempts: type: "integer"
										initialInterval: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											"x-kubernetes-int-or-string": true
										}
									}
									type: "object"
								}
								stripPrefix: {
									description: "StripPrefix holds the StripPrefix configuration."
									properties: {
										forceSlash: type: "boolean"
										prefixes: {
											items: type: "string"
											type: "array"
										}
									}
									type: "object"
								}
								stripPrefixRegex: {
									description: "StripPrefixRegex holds the StripPrefixRegex configuration."
									properties: regex: {
										items: type: "string"
										type: "array"
									}
									type: "object"
								}
							}
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"middlewaretcps.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "middlewaretcps.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "MiddlewareTCP"
				listKind: "MiddlewareTCPList"
				plural:   "middlewaretcps"
				singular: "middlewaretcp"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "MiddlewareTCP is a specification for a MiddlewareTCP resource."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "MiddlewareTCPSpec holds the MiddlewareTCP configuration."
							properties: ipWhiteList: {
								description: "TCPIPWhiteList holds the TCP ip white list configuration."
								properties: sourceRange: {
									items: type: "string"
									type: "array"
								}
								type: "object"
							}
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"serverstransports.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "serverstransports.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "ServersTransport"
				listKind: "ServersTransportList"
				plural:   "serverstransports"
				singular: "serverstransport"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "ServersTransport is a specification for a ServersTransport resource."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "ServersTransportSpec options to configure communication between Traefik and the servers."
							properties: {
								certificatesSecrets: {
									description: "Certificates for mTLS."
									items: type: "string"
									type: "array"
								}
								disableHTTP2: {
									description: "Disable HTTP/2 for connections with backend servers."
									type:        "boolean"
								}
								forwardingTimeouts: {
									description: "Timeouts for requests forwarded to the backend servers."
									properties: {
										dialTimeout: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											description:                  "The amount of time to wait until a connection to a backend server can be established. If zero, no timeout exists."
											"x-kubernetes-int-or-string": true
										}
										idleConnTimeout: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											description:                  "The maximum period for which an idle HTTP keep-alive connection will remain open before closing itself."
											"x-kubernetes-int-or-string": true
										}
										responseHeaderTimeout: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											description:                  "The amount of time to wait for a server's response headers after fully writing the request (including its body, if any). If zero, no timeout exists."
											"x-kubernetes-int-or-string": true
										}
									}
									type: "object"
								}
								insecureSkipVerify: {
									description: "Disable SSL certificate verification."
									type:        "boolean"
								}
								maxIdleConnsPerHost: {
									description: "If non-zero, controls the maximum idle (keep-alive) to keep per-host. If zero, DefaultMaxIdleConnsPerHost is used."
									type:        "integer"
								}
								peerCertURI: {
									description: "URI used to match against SAN URI during the peer certificate verification."
									type:        "string"
								}
								rootCAsSecrets: {
									description: "Add cert file for self-signed certificate."
									items: type: "string"
									type: "array"
								}
								serverName: {
									description: "ServerName used to contact the server."
									type:        "string"
								}
							}
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"tlsoptions.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "tlsoptions.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "TLSOption"
				listKind: "TLSOptionList"
				plural:   "tlsoptions"
				singular: "tlsoption"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "TLSOption is a specification for a TLSOption resource."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "TLSOptionSpec configures TLS for an entry point."
							properties: {
								alpnProtocols: {
									items: type: "string"
									type: "array"
								}
								cipherSuites: {
									items: type: "string"
									type: "array"
								}
								clientAuth: {
									description: "ClientAuth defines the parameters of the client authentication part of the TLS connection, if any."
									properties: {
										clientAuthType: {
											description: "ClientAuthType defines the client authentication type to apply."
											enum: ["NoClientCert", "RequestClientCert", "RequireAnyClientCert", "VerifyClientCertIfGiven", "RequireAndVerifyClientCert"]
											type: "string"
										}
										secretNames: {
											description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
											items: type: "string"
											type: "array"
										}
									}
									type: "object"
								}
								curvePreferences: {
									items: type: "string"
									type: "array"
								}
								maxVersion: type:               "string"
								minVersion: type:               "string"
								preferServerCipherSuites: type: "boolean"
								sniStrict: type:                "boolean"
							}
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"tlsstores.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "tlsstores.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "TLSStore"
				listKind: "TLSStoreList"
				plural:   "tlsstores"
				singular: "tlsstore"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "TLSStore is a specification for a TLSStore resource."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "TLSStoreSpec configures a TLSStore resource."
							properties: defaultCertificate: {
								description: "DefaultCertificate holds a secret name for the TLSOption resource."
								properties: secretName: {
									description: "SecretName is the name of the referenced Kubernetes Secret to specify the certificate details."
									type:        "string"
								}
								required: ["secretName"]
								type: "object"
							}
							required: ["defaultCertificate"]
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
	"traefikservices.traefik.containo.us": {
		apiVersion: "apiextensions.k8s.io/v1"
		kind:       "CustomResourceDefinition"
		metadata: {
			annotations: "controller-gen.kubebuilder.io/version": "v0.6.2"
			creationTimestamp: null
			name:              "traefikservices.traefik.containo.us"
		}
		spec: {
			group: "traefik.containo.us"
			names: {
				kind:     "TraefikService"
				listKind: "TraefikServiceList"
				plural:   "traefikservices"
				singular: "traefikservice"
			}
			scope: "Namespaced"
			versions: [{
				name: "v1alpha1"
				schema: openAPIV3Schema: {
					description: "TraefikService is the specification for a service (that an IngressRoute refers to) that is usually not a terminal service (i.e. not a pod of servers), as opposed to a Kubernetes Service. That is to say, it usually refers to other (children) services, which themselves can be TraefikServices or Services."
					properties: {
						apiVersion: {
							description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
							type:        "string"
						}
						kind: {
							description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
							type:        "string"
						}
						metadata: type: "object"
						spec: {
							description: "ServiceSpec defines whether a TraefikService is a load-balancer of services or a mirroring service."
							properties: {
								mirroring: {
									description: "Mirroring defines a mirroring service, which is composed of a main load-balancer, and a list of mirrors."
									properties: {
										kind: {
											enum: ["Service", "TraefikService"]
											type: "string"
										}
										maxBodySize: {
											format: "int64"
											type:   "integer"
										}
										mirrors: {
											items: {
												description: "MirrorService defines one of the mirrors of a Mirroring service."
												properties: {
													kind: {
														enum: ["Service", "TraefikService"]
														type: "string"
													}
													name: {
														description: "Name is a reference to a Kubernetes Service object (for a load-balancer of servers), or to a TraefikService object (service load-balancer, mirroring, etc). The differentiation between the two is specified in the Kind field."
														type:        "string"
													}
													namespace: type:      "string"
													passHostHeader: type: "boolean"
													percent: type:        "integer"
													port: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														"x-kubernetes-int-or-string": true
													}
													responseForwarding: {
														description: "ResponseForwarding holds configuration for the forward of the response."
														properties: flushInterval: type: "string"
														type: "object"
													}
													scheme: type:           "string"
													serversTransport: type: "string"
													sticky: {
														description: "Sticky holds the sticky configuration."
														properties: cookie: {
															description: "Cookie holds the sticky configuration based on cookie."
															properties: {
																httpOnly: type: "boolean"
																name: type:     "string"
																sameSite: type: "string"
																secure: type:   "boolean"
															}
															type: "object"
														}
														type: "object"
													}
													strategy: type: "string"
													weight: {
														description: "Weight should only be specified when Name references a TraefikService object (and to be precise, one that embeds a Weighted Round Robin)."
														type:        "integer"
													}
												}
												required: ["name"]
												type: "object"
											}
											type: "array"
										}
										name: {
											description: "Name is a reference to a Kubernetes Service object (for a load-balancer of servers), or to a TraefikService object (service load-balancer, mirroring, etc). The differentiation between the two is specified in the Kind field."
											type:        "string"
										}
										namespace: type:      "string"
										passHostHeader: type: "boolean"
										port: {
											anyOf: [{
												type: "integer"
											}, {
												type: "string"
											}]
											"x-kubernetes-int-or-string": true
										}
										responseForwarding: {
											description: "ResponseForwarding holds configuration for the forward of the response."
											properties: flushInterval: type: "string"
											type: "object"
										}
										scheme: type:           "string"
										serversTransport: type: "string"
										sticky: {
											description: "Sticky holds the sticky configuration."
											properties: cookie: {
												description: "Cookie holds the sticky configuration based on cookie."
												properties: {
													httpOnly: type: "boolean"
													name: type:     "string"
													sameSite: type: "string"
													secure: type:   "boolean"
												}
												type: "object"
											}
											type: "object"
										}
										strategy: type: "string"
										weight: {
											description: "Weight should only be specified when Name references a TraefikService object (and to be precise, one that embeds a Weighted Round Robin)."
											type:        "integer"
										}
									}
									required: ["name"]
									type: "object"
								}
								weighted: {
									description: "WeightedRoundRobin defines a load-balancer of services."
									properties: {
										services: {
											items: {
												description: "Service defines an upstream to proxy traffic."
												properties: {
													kind: {
														enum: ["Service", "TraefikService"]
														type: "string"
													}
													name: {
														description: "Name is a reference to a Kubernetes Service object (for a load-balancer of servers), or to a TraefikService object (service load-balancer, mirroring, etc). The differentiation between the two is specified in the Kind field."
														type:        "string"
													}
													namespace: type:      "string"
													passHostHeader: type: "boolean"
													port: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														"x-kubernetes-int-or-string": true
													}
													responseForwarding: {
														description: "ResponseForwarding holds configuration for the forward of the response."
														properties: flushInterval: type: "string"
														type: "object"
													}
													scheme: type:           "string"
													serversTransport: type: "string"
													sticky: {
														description: "Sticky holds the sticky configuration."
														properties: cookie: {
															description: "Cookie holds the sticky configuration based on cookie."
															properties: {
																httpOnly: type: "boolean"
																name: type:     "string"
																sameSite: type: "string"
																secure: type:   "boolean"
															}
															type: "object"
														}
														type: "object"
													}
													strategy: type: "string"
													weight: {
														description: "Weight should only be specified when Name references a TraefikService object (and to be precise, one that embeds a Weighted Round Robin)."
														type:        "integer"
													}
												}
												required: ["name"]
												type: "object"
											}
											type: "array"
										}
										sticky: {
											description: "Sticky holds the sticky configuration."
											properties: cookie: {
												description: "Cookie holds the sticky configuration based on cookie."
												properties: {
													httpOnly: type: "boolean"
													name: type:     "string"
													sameSite: type: "string"
													secure: type:   "boolean"
												}
												type: "object"
											}
											type: "object"
										}
									}
									type: "object"
								}
							}
							type: "object"
						}
					}
					required: ["metadata", "spec"]
					type: "object"
				}
				served:  true
				storage: true
			}]
		}
	}
}
