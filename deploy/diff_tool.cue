package k8s

import "encoding/yaml"

command: diff: {
	task: kube: {
		kind: "exec"
		cmd:    "kubectl diff -f -"
		stdin:  yaml.MarshalStream(objects)
	}
}
