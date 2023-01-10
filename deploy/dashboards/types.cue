package dashboards

import "strings"

#Variable: V={
	type:          string
	_validateType: #VariableTypes[V.type].type
	...
}

#VariableStructs: [#ConstantVariable, #TextboxVariable, #AdHocVariable, #QueryVariable, #DatasourceVariable, #CustomVariable]
#VariableTypes: {for _, v in #VariableStructs {"\(v.type)": v}}

#ConstantVariable: {
	type:        "constant"
	hide:        int | *2
	name:        string
	query:       string
	skipUrlSync: bool | *false
}

#TextboxVariable: {
	current: {
		selected: false
		text:     ""
		value:    ""
	}
	hide:  int | *0
	label: string
	name:  string
	options: []
	skipUrlSync: bool | *false
	type:        "textbox"
}

#AdHocVariable: {
	datasource: {
		type: "grafana-clickhouse-datasource"
		uid:  "${datasource}"
	}
	filters: []
	hide:        int | *0
	name:        string
	label:       string
	skipUrlSync: bool | *false
	type:        "adhoc"
}

#QueryVariable: V={
	current: {
		isNone:   bool | *true
		selected: false
		text:     string | *"All"
		value:    string | *""
	}
	datasource: {
		type: "grafana-clickhouse-datasource"
		uid:  "${datasource}"
	}
	definition: V.query
	hide:       int | *0
	includeAll: bool | *false
	label:      string
	multi:      bool | *false
	name:       string
	options: []
	query:       string
	refresh:     int | *1
	regex:       string | *""
	skipUrlSync: bool | *false
	sort:        int | *0
	type:        "query"
}

#DatasourceVariable: {
	current: {
		selected: false
		text:     "ClickHouse"
		value:    "ClickHouse"
	}
	hide:       int | *0
	includeAll: bool | *false
	label:      string
	multi:      bool | *false
	name:       string
	options: []
	query:       "grafana-clickhouse-datasource"
	refresh:     int | *1
	regex:       string | *""
	skipUrlSync: bool | *false
	type:        "datasource"
}

#CustomVariable: V={
	current: {
		_option:  [ for _, v in V.options if v.selected {v}, {text: "", value: ""}][0]
		selected: false
		text:     _option.text
		value:    _option.value
	}
	hide:       0
	includeAll: false
	label:      string
	multi:      false
	name:       string
	options: [...{
		selected: bool
		text:     string
		value:    string
	}]
	query:       strings.Join([ for _, v in V.options {"\(v.text) : \(v.value)"}], ",")
	queryValue:  ""
	skipUrlSync: false
	type:        "custom"
}

// ---

#Panel: V={
	type:          string
	_validateType: #PanelTypes[V.type].type
	...
}

#PanelStructs: [#TextPanel, #SingleStatPanel, #TimeSeriesPanel, #RowPanel, #TablePanel, #HeatmapPanel, #NetsageSankeyPanel, #NewsPanel, #DashListPanel]
#PanelTypes: {for _, v in #PanelStructs {"\(v.type)": v}}

#BasePanel: V={
	id:           int
	title:        string
	description?: string
	type:         string

	datasource: {
		type: "grafana-clickhouse-datasource"
		uid:  "${datasource}"
	}
	gridPos: {
		h: int | *12
		w: int | *12
		x: int | *0
		y: int | *0
	}

	fieldConfig: defaults: {
		displayName?: string
		unit?:        string
		color: fixedColor: string | *"green"
		color: mode:       "fixed" | "thresholds" | *"palette-classic"
		mappings: []
		thresholds: {
			mode: "absolute"
			steps: [...{
				color: string
				value: int | null
			}]
		}
		thresholds: steps: [{
			color: "green"
			value: null
		}]
	}
	fieldConfig: overrides: [...{
		matcher: {
			id:      string
			options: string
		}
		properties: [...{
			id:    string
			value: string
		}]
	}]

	targets: [...{
		datasource: V.datasource
		format:     0
		queryType:  "sql"
		rawSql:     string
		refId:      string | *"A"
	}]
}

#TextPanel: {
	#BasePanel

	options: {
		code: {
			language:        "plaintext"
			showLineNumbers: false
			showMiniMap:     false
		}
		content: string
		mode:    *"markdown" | "html"
	}
	type: "text"
}

#SingleStatPanel: {
	#BasePanel

	options: {
		colorMode:   "value"
		graphMode:   "area"
		justifyMode: "auto"
		orientation: "auto"
		reduceOptions: {
			calcs: [
				"lastNotNull",
			]
			fields: ""
			values: false
		}
		textMode: "auto"
	}

	type: "stat"
}

#TimeSeriesPanel: {
	#BasePanel
	fieldConfig: defaults: fieldConfig: defaults: custom: {
		axisCenteredZero: false
		axisColorMode:    "text"
		axisLabel:        ""
		axisPlacement:    "auto"
		barAlignment:     0
		drawStyle:        "line"
		fillOpacity:      0
		gradientMode:     "none"
		hideFrom: {
			legend:  false
			tooltip: false
			viz:     false
		}
		lineInterpolation: "linear"
		lineWidth:         1
		pointSize:         5
		scaleDistribution: type: "linear"
		showPoints: "auto"
		spanNulls:  false
		stacking: {
			group: "A"
			mode:  "none"
		}
		thresholdsStyle: mode: "off"
	}
	options: {
		legend: {
			calcs: []
			displayMode: "list"
			placement:   "bottom"
			showLegend:  true
		}
		tooltip: {
			mode: "single"
			sort: "none"
		}
	}
	type: "timeseries"
}

#RowPanel: {
	gridPos: {h: 1, w: 24, x: 0, y: int}
	id:    int
	title: string
	type:  "row"
}

#TablePanel: {
	#BasePanel
	fieldConfig: defaults: custom: {
		align:       "auto"
		displayMode: "auto"
		inspect:     false
	}
	options: {
		footer: {
			fields: ""
			reducer: [
				"sum",
			]
			show: false
		}
		showHeader: true
	}
	type: "table"
}

#HeatmapPanel: {
	#BasePanel
	fieldConfig: {
		defaults: custom: {
			hideFrom: {
				legend:  false
				tooltip: false
				viz:     false
			}
			scaleDistribution: type: "linear"
		}
		overrides: []
	}
	options: {
		calculate: true
		calculation: {
			xBuckets: {
				mode:  string
				value: int
			}
			yBuckets: {
				mode:  string
				value: int
			}
		}
		cellGap: 1
		color: {
			max?:     int
			exponent: 0.5
			fill:     "dark-orange"
			mode:     "scheme"
			reverse:  false
			scale:    "exponential"
			scheme:   "Turbo"
			steps:    128
		}
		exemplars: color:  "rgba(255,0,255,0.7)"
		filterValues: le:  "1e-9"
		legend: show:      false
		rowsFrame: layout: "auto"
		tooltip: {
			show:       true
			yHistogram: false
		}
		yAxis: {
			axisPlacement: "left"
			max?:          int
			min?:          int
			reverse:       false
			unit:          string | *"short"
		}
	}
	type: "heatmap"
}

#NetsageSankeyPanel: {
	#BasePanel
	options: {
		color:       "blue"
		iteration:   int | *7
		monochrome:  false
		nodeColor:   "grey"
		nodePadding: int | *30
		nodeWidth:   int | *30
	}
	type: "netsage-sankey-panel"
}

#NewsPanel: {
	#BasePanel
	options: {
		feedUrl:   string
		showImage: *false | bool
	}
	type: "news"
}

#DashListPanel: {
	#BasePanel
	options: {
		folderId?:          0
		maxItems:           0
		query:              string | *""
		showHeadings:       false
		showRecentlyViewed: false
		showSearch:         true
		showStarred:        false
		tags: [...string]
	}
	type: "dashlist"
}
