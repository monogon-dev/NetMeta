package k8s

// TODO(leo): we might want to bake this into the containers if it grows?

k8s: clickhouseinstallations: netmeta: spec: configuration: files: {
	"IPProtocols.dict": #"""
		    <yandex>
		        <dictionary>
		            <name>IPProtocols</name>
		            <source>
		                <file>
		                    <path>/etc/clickhouse-server/config.d/IPProtocols.tsv</path>
		                    <format>TSV</format>
		                </file>
		            </source>
		            <lifetime>60</lifetime>
		            <layout><flat/></layout>
		            <structure>
		                <id>
		                    <name>ID</name>
		                </id>
		                <attribute>
		                    <name>Name</name>
		                    <type>String</type>
		                    <null_value />
		                </attribute>
		            </structure>
		        </dictionary>
		    </yandex>
		"""#

	// curl -s https://www.iana.org/assignments/protocol-numbers/protocol-numbers-1.csv | awk -F ',' '{ print $1 "\t" $2 }'
	// plus some manual post-processing. Most of them are never seen on the wire, but doesn't hurt to have the full list.
	"IPProtocols.tsv": #"""
		0	NULL
		1	ICMP
		2	IGMP
		3	GGP
		4	IPv4
		5	ST
		6	TCP
		7	CBT
		8	EGP
		9	IGP
		10	BBN-RCC-MON
		11	NVP-II
		12	PUP
		14	EMCON
		15	XNET
		16	CHAOS
		17	UDP
		18	MUX
		19	DCN-MEAS
		20	HMP
		21	PRM
		22	XNS-IDP
		23	TRUNK-1
		24	TRUNK-2
		25	LEAF-1
		26	LEAF-2
		27	RDP
		28	IRTP
		29	ISO-TP4
		30	NETBLT
		31	MFE-NSP
		32	MERIT-INP
		33	DCCP
		34	3PC
		35	IDPR
		36	XTP
		37	DDP
		38	IDPR-CMTP
		39	TP++
		40	IL
		41	IPv6
		42	SDRP
		43	IPv6-Route
		44	IPv6-Frag
		45	IDRP
		46	RSVP
		47	GRE
		48	DSR
		49	BNA
		50	ESP
		51	AH
		52	I-NLSP
		54	NARP
		55	MOBILE
		56	TLSP
		57	SKIP
		58	IPv6-ICMP
		59	IPv6-NoNxt
		60	IPv6-Opts
		62	CFTP
		64	SAT-EXPAK
		65	KRYPTOLAN
		66	RVD
		67	IPPC
		69	SAT-MON
		70	VISA
		71	IPCV
		72	CPNX
		73	CPHB
		74	WSN
		75	PVP
		76	BR-SAT-MON
		77	SUN-ND
		78	WB-MON
		79	WB-EXPAK
		80	ISO-IP
		81	VMTP
		82	SECURE-VMTP
		83	VINES
		84	TTP
		84	IPTM
		85	NSFNET-IGP
		86	DGP
		87	TCF
		88	EIGRP
		89	OSPFIGP
		90	Sprite-RPC
		91	LARP
		92	MTP
		93	AX.25
		94	IPIP
		96	SCC-SP
		97	ETHERIP
		98	ENCAP
		100	GMTP
		101	IFMP
		102	PNNI
		103	PIM
		104	ARIS
		105	SCPS
		106	QNX
		107	A/N
		108	IPComp
		109	SNP
		110	Compaq-Peer
		111	IPX-in-IP
		112	VRRP
		113	PGM
		115	L2TP
		116	DDX
		117	IATP
		118	STP
		119	SRP
		120	UTI
		121	SMP
		123	PTP
		124	ISISv4
		125	FIRE
		126	CRTP
		127	CRUDP
		128	SSCOPMCE
		129	IPLT
		130	SPS
		131	PIPE
		132	SCTP
		133	FC
		134	RSVP-E2E-IGNORE
		135	Mobility Header
		136	UDPLite
		137	MPLS-in-IP
		138	manet
		139	HIP
		140	Shim6
		141	WESP
		142	ROHC
		143	Ethernet
		"""#

	"EtherTypes.dict": #"""
		<yandex>
		    <dictionary>
		        <name>EtherTypes</name>
		        <source>
		            <file>
		                <path>/etc/clickhouse-server/config.d/EtherTypes.tsv</path>
		                <format>TSV</format>
		            </file>
		        </source>
		        <lifetime>60</lifetime>
		        <layout><flat/></layout>
		        <structure>
		            <id>
		                <name>ID</name>
		            </id>
		            <attribute>
		                <name>Name</name>
		                <type>String</type>
		                <null_value>0</null_value>
		            </attribute>
		        </structure>
		    </dictionary>
		</yandex>
		"""#

	// Adapted from https://en.wikipedia.org/wiki/EtherType
	// Full list at https://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.xhtml
	//
	// print('\n'.join('\t'.join((str(int(a, 16)), b)) for a, b in (x.strip().split('\t') for x in inf.strip().split('\n'))))

	"EtherTypes.tsv": #"""
		0	NULL
		2048	IPv4
		2054	ARP
		2114	Wake-on-LAN
		8944	AVTP
		8947	IETF TRILL
		8938	Stream Reservation Protocol
		24578	DEC MOP RC
		24579	DECnet Phase IV
		24580	DEC LAT
		32821	RARP
		32923	AppleTalk
		33011	AppleTalk AARP
		33024	IEEE 802.1Q
		33026	SLPP
		33027	VLACP
		33079	IPX
		33284	QNX Qnet
		34525	IPv6
		34824	Ethernet flow control
		34825	LACP
		34841	CobraNet
		34887	MPLS unicast
		34888	MPLS multicast
		34915	PPPoE Discovery
		34916	PPPoE Session
		34939	HomePlug 1.0 MME
		34958	EAP over LAN
		34962	PROFINET Protocol
		34970	HyperSCSI
		34978	ATA over Ethernet
		34980	EtherCAT Protocol
		34984	Q-in-Q S-Tag
		34987	Powerlink
		35000	GOOSE
		35001	GSE
		35002	Sampled Value Transmission
		35007	MikroTik RoMON
		35020	LLDP
		35021	SERCOS III
		35036	WSMP
		35043	IEC62439-2
		35045	MACSEC
		35047	IEEE 802.1ah PBB
		35063	Precision Time Protocol
		35064	NC-SI
		35067	PRP
		35074	ITU-T Y.1731 (OAM)
		35078	FCoE
		35092	FCoE Init
		35093	RDMA RoCE
		35101	TTE
		35119	HSR
		36864	ECTP
		37120	IEEE 802.1Q double tag
		61889	IEEE 802.1CB
		"""#

	"TCPFlags.dict": #"""
		<yandex>
		    <dictionary>
		        <name>TCPFlags</name>
		        <source>
		            <file>
		                <path>/etc/clickhouse-server/config.d/TCPFlags.tsv</path>
		                <format>TSV</format>
		            </file>
		        </source>
		        <lifetime>60</lifetime>
		        <layout><flat/></layout>
		        <structure>
		            <id>
		                <name>ID</name>
		            </id>
		            <attribute>
		                <name>Name</name>
		                <type>String</type>
		                <null_value />
		            </attribute>
		        </structure>
		    </dictionary>
		</yandex>
		"""#

	// Source: https://tools.ietf.org/html/rfc793
	"TCPFlags.tsv": #"""
		1	FIN
		2	SYN
		4	RST
		8	PSH
		16	ACK
		32	URG
		64	ECE
		128	CWR
		"""#

	// TODO: deduplicate (https://github.com/leoluk/NetMeta/issues/6)
	"FlowMessage.proto": #"""
		syntax = "proto3";
		package netmeta;

		// Adapter from/compatible with cloudflare/goflow.

		message FlowMessage {
		    enum FlowType {
		        FLOWUNKNOWN = 0;
		        SFLOW_5 = 1;
		        NETFLOW_V5 = 2;
		        NETFLOW_V9 = 3;
		        IPFIX = 4;
		    }
		    FlowType Type = 1;

		    uint64 TimeReceived = 2;
		    uint32 SequenceNum = 4;
		    uint64 SamplingRate = 3;

		    uint32 FlowDirection = 42;

		    // Sampler information
		    bytes SamplerAddress = 11;

		    // Found inside packet
		    uint64 TimeFlowStart = 38;
		    uint64 TimeFlowEnd = 5;

		    // Size of the sampled packet
		    uint64 Bytes = 9;
		    uint64 Packets = 10;

		    // Source/destination addresses
		    bytes SrcAddr = 6;
		    bytes DstAddr = 7;

		    // Layer 3 protocol (IPv4/IPv6/ARP/MPLS...)
		    uint32 Etype = 30;

		    // Layer 4 protocol
		    uint32 Proto = 20;

		    // Ports for UDP and TCP
		    uint32 SrcPort = 21;
		    uint32 DstPort = 22;

		    // Interfaces
		    uint32 InIf = 18;
		    uint32 OutIf = 19;

		    // Ethernet information
		    uint64 SrcMac = 27;
		    uint64 DstMac = 28;

		    // Vlan
		    uint32 SrcVlan = 33;
		    uint32 DstVlan = 34;
		    // 802.1q VLAN in sampled packet
		    uint32 VlanId = 29;

		    // VRF
		    uint32 IngressVrfID = 39;
		    uint32 EgressVrfID = 40;

		    // IP and TCP special flags
		    uint32 IPTos = 23;
		    uint32 ForwardingStatus = 24;
		    uint32 IPTTL = 25;
		    uint32 TCPFlags = 26;
		    uint32 IcmpType = 31;
		    uint32 IcmpCode = 32;
		    uint32 IPv6FlowLabel = 37;
		    // Fragments (IPv4/IPv6)
		    uint32 FragmentId = 35;
		    uint32 FragmentOffset = 36;
		    uint32 BiFlowDirection = 41;

		    // Autonomous system information
		    uint32 SrcAS = 14;
		    uint32 DstAS = 15;

		    bytes NextHop = 12;
		    uint32 NextHopAS = 13;

		    // Prefix size
		    uint32 SrcNet = 16;
		    uint32 DstNet = 17;

		    // IP encapsulation information
		    bool HasEncap = 43;
		    bytes SrcAddrEncap = 44;
		    bytes DstAddrEncap = 45;
		    uint32 ProtoEncap = 46;
		    uint32 EtypeEncap = 47;

		    uint32 IPTosEncap = 48;
		    uint32 IPTTLEncap = 49;
		    uint32 IPv6FlowLabelEncap = 50;
		    uint32 FragmentIdEncap = 51;
		    uint32 FragmentOffsetEncap = 52;

		    // MPLS information
		    bool HasMPLS = 53;
		    uint32 MPLSCount = 54;
		    uint32 MPLS1TTL = 55; // First TTL
		    uint32 MPLS1Label = 56; // First Label
		    uint32 MPLS2TTL = 57; // Second TTL
		    uint32 MPLS2Label = 58; // Second Label
		    uint32 MPLS3TTL = 59; // Third TTL
		    uint32 MPLS3Label = 60; // Third Label
		    uint32 MPLSLastTTL = 61; // Last TTL
		    uint32 MPLSLastLabel = 62; // Last Label

		    // PPP information
		    bool HasPPP = 63;
		    uint32 PPPAddressControl = 64;

		    // Custom fields: start after ID 1000:
		    // uint32 MyCustomField = 1000;
		}
		"""#
}
