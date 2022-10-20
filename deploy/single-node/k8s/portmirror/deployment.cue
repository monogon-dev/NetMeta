package portmirror

import "net"

#Config: {
	digest:         string
	image:          string
	interfaces:     string
	sampleRate:     int
	samplerAddress: net.IP
}

Deployment: portmirror: {
	M=metadata: labels: app: "portmirror"
	spec: {
		strategy: type: "Recreate"
		selector: matchLabels: app: M.labels.app
		template: {
			metadata: labels: app: M.labels.app

			// Trigger redeployment when digest changes.
			metadata: annotations: "meta/local-image-digest": #Config.digest

			spec: {
				dnsPolicy:   "ClusterFirstWithHostNet"
				containers: [
					{
						name:  "portmirror"
						image: #Config.image

						args: [
							"-kafka.brokers=netmeta-kafka-bootstrap:9092",
							"-kafka.log.err=true",
							"-proto.fixedlen=true",
							"-loglevel=debug",
							"-iface=\(#Config.interfaces)",
							"-samplerate=\(#Config.sampleRate)",
							"-sampler-address=\(#Config.samplerAddress)",
						]
						securityContext: capabilities: add: ["NET_ADMIN"]
					},
				]
			}
		}
	}
}
