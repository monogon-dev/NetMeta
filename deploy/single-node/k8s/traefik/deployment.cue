package traefik

import (
	"list"
)

#Config: {
	ports: {
		// Frontend (HTTP is redirected to HTTPS)
		http:       int | *80
		https:      int | *443
		clickhouse: int | *8123
	}

	// Let's Encrypt Mode
	//  - off: self-signed certificate (TODO, right now, it just disables certificates altogether)
	//  - staging: staging Let's Encrypt server (recommended for testing!)
	//  - production: production Let's Encrypt server (beware of rate limits)
	//
	// Switching between staging and production will not automatically
	// delete the existing certificate - delete acme.json and restart Traefik.
	letsencryptMode: *"staging" | "production" | "off"

	// Let's Encrypt Account Email Address
	letsencryptAccountMail: string

	// Expose the ClickHouse HTTP query API on the port defined above.
	enableClickhouseIngress: bool | *false
}

ServiceAccount: "traefik-ingress-controller": {}

PersistentVolumeClaim: "traefik-data": {}

TLSOption: default: spec: {
	minVersion: "VersionTLS12"
	cipherSuites: [
		"TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
		"TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256",
		"TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
		"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
		"TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
		"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
	]
}

Deployment: traefik: {
	metadata: labels: app: "traefik"
	spec: {
		replicas: 1
		strategy: type: "Recreate"
		selector: matchLabels: app: "traefik"
		template: {
			metadata: labels: app: "traefik"
			spec: {
				// The poor-man's LoadBalancer implementation in k3s does not support IPv6 and is limited to legacy IPv4.
				// Bypass this inconvenience by running traefik in the host network namespace.
				hostNetwork:        true
				serviceAccountName: "traefik-ingress-controller"
				containers: [{
					name:  "traefik"
					image: "docker.io/traefik:v2.9.1@sha256:3eaf50b7874f63567ee5d18498536928faef199302c805cb6b766e06b649302d"

					let _args = [
						[
							"--accesslog",
							"--entrypoints.web.Address=:\(#Config.ports.http)",
							"--entrypoints.websecure.Address=:\(#Config.ports.https)",
							"--providers.kubernetescrd",
						],
						if #Config.letsencryptMode != "off" {
							[
								"--certificatesresolvers.publicHostnameResolver.acme.tlschallenge",
								"--certificatesresolvers.publicHostnameResolver.acme.email=\(#Config.letsencryptAccountMail)",
								"--certificatesresolvers.publicHostnameResolver.acme.storage=/data/acme-\(#Config.letsencryptMode).json",
							]
						},
						if #Config.letsencryptMode == "staging" {
							[
								"--certificatesresolvers.publicHostnameResolver.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory",
							]
						},
						if #Config.enableClickhouseIngress {
							[
								"--entrypoints.clickhouse.Address=:\(#Config.ports.clickhouse)",
							]
						},
					]

					args: list.FlattenN(_args, 1)

					ports: [{
						name:          "web"
						containerPort: #Config.ports.http
						protocol:      "TCP"
					}, {
						name:          "websecure"
						containerPort: #Config.ports.https
						protocol:      "TCP"
					}, {
						name:          "clickhouse"
						containerPort: #Config.ports.clickhouse
						protocol:      "TCP"
					}]

					volumeMounts: [{
						mountPath: "/data"
						name:      "traefik-data"
					}]
				}]
				restartPolicy: "Always"
				volumes: [{
					name: "traefik-data"
					persistentVolumeClaim: claimName: "traefik-data"
				}]
			}
		}
	}
}
