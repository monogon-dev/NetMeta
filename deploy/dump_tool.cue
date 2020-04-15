package k8s

import "encoding/yaml"

command: dump: {
	task: print: {
		kind: "print"
		text: yaml.MarshalStream(objects)
	}
}
