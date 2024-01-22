package clickhouse

// curl -s https://www.iana.org/assignments/protocol-numbers/protocol-numbers-1.csv | awk -F ',' '{ print $1 "\t" $2 }'
// plus some manual post-processing. Most of them are never seen on the wire, but doesn't hurt to have the full list.
_files: IPProtocols: cfg: {
	layout: flat: null
	structure: {
		id: name: "ID"
		attribute: {
			name:       "Name"
			type:       "String"
			null_value: null
		}
	}
}
_files: IPProtocols: data: #"""
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

// Adapted from https://en.wikipedia.org/wiki/EtherType
// Full list at https://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.xhtml
//
// print('\n'.join('\t'.join((str(int(a, 16)), b)) for a, b in (x.strip().split('\t') for x in inf.strip().split('\n'))))
_files: EtherTypes: cfg: {
	layout: flat: null
	structure: {
		id: name: "ID"
		attribute: {
			name:       "Name"
			type:       "String"
			null_value: 0
		}
	}
}
_files: EtherTypes: data: #"""
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

// Source: https://tools.ietf.org/html/rfc793
_files: TCPFlags: cfg: {
	layout: flat: null
	structure: {
		id: name: "ID"
		attribute: {
			name:       "Name"
			type:       "String"
			null_value: null
		}
	}
}
_files: TCPFlags: data: #"""
	1	FIN
	2	SYN
	4	RST
	8	PSH
	16	ACK
	32	URG
	64	ECE
	128	CWR
	"""#
