package k8s

import "encoding/yaml"

command: apply: {
	task: kube: {
		kind: "exec"
		cmd:    "kubectl apply --all -f -"
		stdin:  yaml.MarshalStream(objects)
	}
}

command: "apply-prune": {
	task: kube: {
		kind: "exec"
		cmd:    "kubectl apply --all -f - --prune=true"
		stdin:  yaml.MarshalStream(objects)
	}
}
