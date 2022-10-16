package clickhouse

ClickhouseInstallation: netmeta: spec: configuration: files: "risinfo.dict": #"""
	    <yandex>
	        <dictionary>
	            <name>risinfo</name>
	            <source>
			    <http>
			        <url>http://risinfo/rib.tsv</url>
			        <format>TabSeparated</format>
			    </http>
	            </source>
	            <lifetime>3600</lifetime>
	            <layout>
		            <ip_trie>
		                <access_to_key_from_attributes>true</access_to_key_from_attributes>
		            </ip_trie>
	            </layout>
		        <structure>
		            <key>
		                <attribute>
		                    <name>prefix</name>
		                    <type>String</type>
		                </attribute>
		            </key>
		            <attribute>
		                <name>asnum</name>
		                <type>UInt32</type>
		                <null_value>0</null_value>
		            </attribute>
		        </structure>
	        </dictionary>
	    </yandex>
	"""#

ClickhouseInstallation: netmeta: spec: configuration: files: "autnums.dict": #"""
	    <yandex>
	        <dictionary>
	            <name>autnums</name>
	            <source>
			    <http>
			        <url>http://risinfo/autnums.tsv</url>
			        <format>TabSeparated</format>
			    </http>
	            </source>
	            <lifetime>86400</lifetime>
	            <layout>
		            <flat />
	            </layout>
		        <structure>
		            <id>
	                    <name>asnum</name>
		            </id>
		            <attribute>
		                <name>name</name>
		                <type>String</type>
		                <null_value></null_value>
		            </attribute>
		            <attribute>
		                <name>country</name>
		                <type>String</type>
		                <null_value></null_value>
		            </attribute>
		        </structure>
	        </dictionary>
	    </yandex>
	"""#
