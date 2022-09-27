package k8s

import (
	"list"
)

k8s: serviceaccounts: "traefik-ingress-controller": {}

k8s: pvcs: "traefik-data": {}

k8s: tlsoptions: default: spec: {
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

k8s: deployments: traefik: {
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
					image: "docker.io/traefik:v2.8.7@sha256:ad7914fcb229ba6569223535ca6574eda78f1eff237a20df2ba744f893cfeaef"

					let _args = [
						[
							"--accesslog",
							"--entrypoints.web.Address=:\(netmeta.config.ports.http)",
							"--entrypoints.websecure.Address=:\(netmeta.config.ports.https)",
							"--providers.kubernetescrd",
						],

						if netmeta.config.letsencryptMode != "off" {
							[
								"--certificatesresolvers.publicHostnameResolver.acme.tlschallenge",
								"--certificatesresolvers.publicHostnameResolver.acme.email=\(netmeta.config.letsencryptAccountMail)",
								"--certificatesresolvers.publicHostnameResolver.acme.storage=/data/acme.json",
							]
						},

						if netmeta.config.letsencryptMode == "staging" {
							[
								"--certificatesresolvers.publicHostnameResolver.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory",
							]
						},

						if netmeta.config.enableClickhouseIngress {
							[
								"--entrypoints.clickhouse.Address=:\(netmeta.config.ports.clickhouse)",
							]
						},
					]

					args: list.FlattenN(_args, 1)

					ports: [{
						name:          "web"
						containerPort: netmeta.config.ports.http
						protocol:      "TCP"
					}, {
						name:          "websecure"
						containerPort: netmeta.config.ports.https
						protocol:      "TCP"
					}, {
						name:          "clickhouse"
						containerPort: netmeta.config.ports.clickhouse
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
