package reconciler

import (
	reconciler "github.com/monogon-dev/NetMeta/reconciler:main"
	"encoding/json"
)

#Config: {
	digest: string
	image:  string
	files: [string]: string
	config:       reconciler.#Config
	databaseHost: string
	databaseUser: string
	databasePass: string
}

ConfigMap: "reconciler-config": data: {
	for name, content in #Config.files {
		"\(name)": content
	}
	"config.json": json.Marshal(#Config.config)
}

Deployment: reconciler: {
	M=metadata: labels: app: "reconciler"

	spec: {
		selector: matchLabels: app: M.labels.app
		template: {
			metadata: labels: app: M.labels.app

			// Trigger redeployment when digest changes.
			metadata: annotations: "meta/local-image-digest": #Config.digest

			spec: containers: [{
				name:            "reconciler"
				imagePullPolicy: "Never"
				image:           #Config.image
				env: [{
					name:  "DB_HOST"
					value: #Config.databaseHost
				}, {
					name:  "DB_USER"
					value: #Config.databaseUser
				}, {
					name:  "DB_PASS"
					value: #Config.databasePass
				}]
				workingDir: "/app"

				volumeMounts: [ for f, _ in ConfigMap["reconciler-config"].data {
					mountPath: "/app/\(f)"
					subPath:   "\(f)"
					name:      "reconciler-config"
				}]
			}]

			spec: volumes: [{
				name: "reconciler-config"
				configMap: name: "reconciler-config"
			}]
		}
	}
}
