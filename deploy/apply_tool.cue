package k8s

import "encoding/yaml"

command: apply: {
	if len(preObjects) > 0 {
		task: prereqs: {
			kind:  "exec"
			cmd:   "k3s kubectl apply --server-side --force-conflicts --all -f -"
			stdin: yaml.MarshalStream(preObjects)
		}
	}

	task: apply: {
		$after: task.prereqs
		kind:   "exec"
		cmd:    "k3s kubectl apply --server-side --force-conflicts --all -f -"
		stdin:  yaml.MarshalStream(objects)
	}
}

command: "apply-prune": {
	task: kube: {
		kind:  "exec"
		cmd:   "k3s kubectl apply --server-side --force-conflicts --all -f - --prune=true"
		stdin: yaml.MarshalStream(preObjects + objects)
	}
}
