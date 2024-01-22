package nix

import (
	"encoding/yaml"
	"encoding/json"
	"strings"
	"tool/file"
)

command: dump: {
	dashboards: {
		outDir: file.MkdirAll & {
			path: "out/dashboards"
		}

		for k, v in out.dashboards {
			let fileName = "\(strings.ToLower(strings.Replace(k, " ", "_", -1))).json"
			"\(outDir.path)/\(fileName)": file.Create & {
				$after:   outDir
				filename: "\(outDir.path)/\(fileName)"
				contents: json.Indent(json.Marshal(v), "", " ")
			}
		}
	}

	clickhouse: {
		outDir: file.MkdirAll & {
			path: "out/clickhouse"
		}

		for k, v in out.clickhouse.files {
			"\(outDir.path)/\(k)": file.Create & {
				$after:   outDir
				filename: "\(outDir.path)/\(k)"
				contents: v
			}
		}
	}

	reconciler: {
		outDir: file.MkdirAll & {
			path: "out/reconciler"
		}

		for k, v in out.reconciler {
			"\(outDir.path)/\(k)": file.Create & {
				$after:   outDir
				filename: "\(outDir.path)/\(k)"
				contents: v
			}
		}
	}

}
