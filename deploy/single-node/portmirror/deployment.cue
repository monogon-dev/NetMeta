package k8s

if netmeta.config.portMirror != null {
	k8s: deployments: portmirror: {
		M=metadata: labels: app: "portmirror"
		spec: {
			strategy: type: "Recreate"
			selector: matchLabels: app: M.labels.app
			template: {
				metadata: labels: app: M.labels.app

				// Trigger redeployment when digest changes.
				metadata: annotations: "meta/local-image-digest": netmeta.images.portmirror.digest

				spec: {
					// k3s does not support IPv6 networking, so we run portmirror in the host network namespace.
					hostNetwork: true
					dnsPolicy:   "ClusterFirstWithHostNet"
					containers: [
						{
							name:  "portmirror"
							image: netmeta.images.portmirror.image

							args: [
								"-kafka.brokers=netmeta-kafka-bootstrap:9092",
								"-kafka.log.err=true",
								"-proto.fixedlen=true",
								"-loglevel=debug",
								"-iface=\(netmeta.config.portMirror.interfaces)",
								"-samplerate=\(netmeta.config.portMirror.sampleRate)",
							]

							// Workaround for mlock crashes until Go 1.16 is released.
							//   https://go-review.googlesource.com/c/go/+/246200/
							//   https://github.com/golang/go/issues/40184
							env: [{name: "GODEBUG", value: "mlock=0"}]
						},
					]
				}
			}
		}
	}
}
