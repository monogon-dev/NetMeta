package k8s

k8s: configmaps: "etc-clickhouse-operator-configd-files": {
	metadata: labels: app: "clickhouse-operator"
	data: {
		"01-clickhouse-listen.xml": """
		<yandex>
		    <!-- Listen wildcard address to allow accepting connections from other containers and host network. -->
		    <listen_host>::</listen_host>
		    <listen_host>0.0.0.0</listen_host>
		    <listen_try>1</listen_try>
		</yandex>

		"""

		"02-clickhouse-logger.xml": """
		<yandex>
		    <logger>
		        <!-- Possible levels: https://github.com/pocoproject/poco/blob/develop/Foundation/include/Poco/Logger.h#L105 -->
		        <level>debug</level>
		        <log>/var/log/clickhouse-server/clickhouse-server.log</log>
		        <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
		        <size>1000M</size>
		        <count>10</count>
		        <!-- Default behavior is autodetection (log to console if not daemon mode and is tty) -->
		        <console>1</console>
		    </logger>
		</yandex>

		"""

		"03-clickhouse-querylog.xml": """
		<yandex>
		<query_log>
		    <database>system</database>
		    <table>query_log</table>
		    <partition_by>toMonday(event_date)</partition_by>
		    <flush_interval_milliseconds>7500</flush_interval_milliseconds>
		</query_log>
		</yandex>

		"""
	}
}
