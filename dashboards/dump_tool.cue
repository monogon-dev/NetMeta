package dashboards

import (
	"encoding/json"
	"strings"
	"tool/file"
)

command: dump: {
	outDir: file.MkdirAll & {
		path: "out"
	}

	for k, v in dashboards {
		let fileName = "\(strings.ToLower(strings.Replace(k, " ", "_", -1))).json"
		"\(outDir.path)/\(fileName)": file.Create & {
			$after:   outDir
			filename: "\(outDir.path)/\(fileName)"
			contents: json.Indent(json.Marshal(v), "", " ")
		}
	}
}
