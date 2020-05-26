package k8s

import "encoding/yaml"

command: diff: {
	task: kube: {
		kind: "exec"
		cmd:    "kubectl diff --server-side --force-conflicts -f -"
		stdin:  yaml.MarshalStream(objects)
	}
}
