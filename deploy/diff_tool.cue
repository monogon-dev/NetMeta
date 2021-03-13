package k8s

import "encoding/yaml"

command: diff: {
	task: kube: {
		kind:  "exec"
		cmd:   "k3s kubectl diff --server-side --force-conflicts -f -"
		stdin: yaml.MarshalStream(preObjects + objects)
	}
}

yo: "yo"
