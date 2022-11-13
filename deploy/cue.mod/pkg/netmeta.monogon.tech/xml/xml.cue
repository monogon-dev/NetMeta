package xml

import "text/template"

_template: #"""
	{{- define "node" -}}
		{{- range $key, $value := . -}}
			{{- $type := $value | printf "%#T" -}}
			{{- if eq "map[string]interface {}" $type -}}
					{{- if eq 0 (len $value) -}}
						<{{ $key }}/>
					{{- else -}}
						<{{ $key }}>{{ template "node" $value }}</{{ $key }}>
					{{- end -}}
			{{- else if eq "[]interface {}" $type -}}
					<{{ $key }}>
					{{- range $v := $value -}}
						{{- template "node" $v -}}
					{{- end -}}
					</{{ $key }}>
			{{- else if eq nil $value -}}
				<{{ $key }}/>
			{{- else -}}
				<{{ $key }}>{{ $value }}</{{ $key }}>
			{{- end -}}
		{{- end -}}
	{{- end -}}

	{{ template "node" . }}
	"""#

#Marshal: {
	IN=in: _
	out:   template.Execute(_template, IN)
}

_xmlTest: #Marshal & {
	in: {
		a: b: c: "d"
		a: c: {}
	}
}

_xmlTest: out: "<a><b><c>d</c></b><c/></a>"
