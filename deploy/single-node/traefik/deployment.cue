package k8s

k8s: serviceaccounts: "traefik-ingress-controller": {}

k8s: pvcs: "traefik-data": {}

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
					image: "traefik:v2.2"

					_letsencryptStaging: [...]

					_letsencrypt: [
						"--certificatesresolvers.publicHostnameResolver.acme.tlschallenge",
						"--certificatesresolvers.publicHostnameResolver.acme.email=\(netmeta.config.letsencryptAccountMail)",
						"--certificatesresolvers.publicHostnameResolver.acme.storage=/data/acme.json",
					]

					if netmeta.config.letsencryptMode == "staging" {
						_letsencryptStaging: [
							"--certificatesresolvers.publicHostnameResolver.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory",
						]
					}

					args: [
						"--accesslog",
						"--entrypoints.web.Address=:80",
						"--entrypoints.websecure.Address=:443",
						"--providers.kubernetescrd",
					] + _letsencrypt + _letsencryptStaging

					ports: [{
						name:          "web"
						containerPort: 80
						protocol:      "TCP"
					}, {
						name:          "websecure"
						containerPort: 443
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
