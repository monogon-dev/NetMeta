package schema

import reconciler "github.com/monogon-dev/NetMeta/reconciler:main"

#Config: {
	fastNetMon?: {
		...
	}
}

function: [NAME=string]: reconciler.#Function & {
	name: NAME
}

view: [NAME=string]: reconciler.#MaterializedView & {
	name: NAME
}

table: [NAME=string]: reconciler.#Table & {
	name: NAME
}
