package k8s

import (
	"encoding/yaml"
	"encoding/json"
	"strings"
	"tool/file"
)

command: dump: {
	task: print: {
		kind: "print"
		text: yaml.MarshalStream(preObjects + objects)
	}
}

command: dump_dashboards: {
	outDir: file.MkdirAll & {
		path: "out/dashboards"
	}

	for k, v in netmeta.dashboards {
		let fileName = "\(strings.ToLower(strings.Replace(k, " ", "_", -1))).json"
		"\(outDir.path)/\(fileName)": file.Create & {
			$after:   outDir
			filename: "\(outDir.path)/\(fileName)"
			contents: json.Indent(json.Marshal(v), "", " ")
		}
	}
}
