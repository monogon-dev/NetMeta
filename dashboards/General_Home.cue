package dashboards

dashboards: Home: {
	#defaultParams: false
	title:          "Home"
	uid:            "NJoydihVk"
	_panels: [{
		gridPos: {h: 3, w: 24, x: 0, y: 0}
		options: {
			content:
				#"""
					<div style="display: flex; background-size: cover; height: 100%; align-items: center; padding: 0 16px; justify-content: space-between; padding: 0 24px;">
					    <h1 style="margin-bottom: 0;">Welcome to NetMeta</h1>
					    <div style="display: flex; align-items: baseline;">
					        <h3 style="margin-bottom: 0; margin-right: 16px">Need help?</h3>
					        <div style="display: flex; flex-wrap: wrap;">
					            <a style="margin-right: 16px; text-decoration: underline; text-wrap: no-wrap; color: rgb(204, 204, 220);"
					               href="https://github.com/monogon-dev/NetMeta/issues" target="_blank">
					                Issue Tracker
					            </a>
					            <a style="margin-right: 16px; text-decoration: underline; text-wrap: no-wrap; color: rgb(204, 204, 220);"
					               href="mailto:contact@monogon.tech">
					                Contact Us
					            </a>
					        </div>
					    </div>
					</div>
					"""#
			mode: "html"
		}
		type:  "text"
		title: ""
	}, {
		gridPos: {h: 6, w: 12, x: 0, y: 3}
		options: {
			maxItems: 0
			tags: ["netmeta"]
		}
		title: "NetMeta Dashboards"
		type:  "dashlist"
	}, {
		gridPos: {h: 9, w: 12, x: 0, y: 9}
		options: {
			query: "Clickhouse -"
		}
		title: "Clickhouse Dashboards"
		type:  "dashlist"
	}, {
		gridPos: {h: 15, w: 12, x: 12, y: 3}
		options: {
			feedUrl:   "https://netmeta-cache.leoluk.de/v1/releases.atom"
			showImage: true
		}
		title: "NetMeta News"
		type:  "news"
	}]
}
