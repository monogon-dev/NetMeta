package k8s

import (
	"encoding/yaml"
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

	for k, v in k8s.configmaps["grafana-dashboards-data"].data {
		"\(outDir.path)/\(k)": file.Create & {
			$after: outDir
			filename: "\(outDir.path)/\(k)"
			contents:  v
		}
	}
}
