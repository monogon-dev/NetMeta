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

// Applies configmaps only
command: "apply-cm": {
	task: apply: {
		kind: "exec"
		cmd:  "k3s kubectl apply --server-side --force-conflicts --all -f -"
		_objects: [ for v in [k8s.configmaps] for x in v {x}]
		stdin:  yaml.MarshalStream(_objects)
		stdout: string
	}
	task: applyDisplay: {
		kind: "print"
		text: task.apply.stdout
	}
}
