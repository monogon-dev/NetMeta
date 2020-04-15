package k8s

import "encoding/yaml"

command: apply: {
	task: kube: {
		kind: "exec"
		cmd:    "kubectl apply --all -f -"
		stdin:  yaml.MarshalStream(objects)
	}
}
