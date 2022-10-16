package clickhouse

import (
	"strings"
	"text/template"
)

#GeneratedTSV: T={
	#in: {
		name: string
		keys: [...{name: string, type: string, nullable: bool | *false}]
		attributes: [...{name: string, type: string, nullable: bool | *false}]
		data: [...[...string]]
	}
	#out: {
		"\(#in.name).dict": template.Execute(T.dictTemplate, #in)
		"\(#in.name).tsv":  strings.Join([ for _, e in #in.data {
			strings.Join(e, "\t")
		}], "\n")
	}

	dictTemplate: #"""
		<yandex>
		    <dictionary>
		        <name>{{ .name }}</name>
		        <source>
		            <file>
		                <path>/etc/clickhouse-server/config.d/{{ .name }}.tsv</path>
		                <format>TSV</format>
		            </file>
		        </source>
		        <lifetime>60</lifetime>
		        <layout><complex_key_hashed/></layout>
		        <structure>
		            <key>
		                {{ range $T := .keys -}}
		                <attribute>
		                    <name>{{ $T.name }}</name>
		                    <type>{{ $T.type }}</type>
		                </attribute>
		                {{ end }}
		            </key>
		            {{ range $T := .attributes -}}
		            <attribute>
		                <name>{{ $T.name }}</name>
		                <type>{{ $T.type }}</type>
		                {{ if $T.nullable -}}
		                <null_value />
		                {{- end }}
		            </attribute>
		            {{- end }}
		        </structure>
		    </dictionary>
		</yandex>
		"""#
}

