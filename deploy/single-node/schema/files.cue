package schema

file: "DBManager.proto":
	// language=proto
	#"""
		syntax = "proto3";
		package netmeta;
		
		import "google/protobuf/descriptor.proto";
		
		extend google.protobuf.FieldOptions {
		  optional string column_type = 50000;
		  optional string column_name = 50001;
		  optional bool column_skip = 50002;
		}
		"""#

file: "FlowMessage.proto":
	// language=proto
	#"""
		syntax = "proto3";
		package netmeta;
		
		import "DBManager.proto";
		
		// Adapter from/compatible with cloudflare/goflow.
		
		message FlowMessage {
		  enum FlowType {
		    FLOWUNKNOWN = 0;
		    SFLOW_5 = 1;
		    NETFLOW_V5 = 2;
		    NETFLOW_V9 = 3;
		    IPFIX = 4;
		  }
		  FlowType Type = 1 [(column_name) = "FlowType"];
		
		  uint64 TimeReceived = 2;
		  uint32 SequenceNum = 4;
		  uint64 SamplingRate = 3;
		
		  uint32 FlowDirection = 42 [(column_type) = "UInt8"];
		
		  // Sampler information
		  bytes SamplerAddress = 11 [(column_type) = "IPv6"];;
		
		  // Found inside packet
		  uint64 TimeFlowStart = 38;
		  uint64 TimeFlowEnd = 5;
		
		  // Size of the sampled packet
		  uint64 Bytes = 9;
		  uint64 Packets = 10;
		
		  // Source/destination addresses
		  bytes SrcAddr = 6 [(column_type) = "IPv6"];
		  bytes DstAddr = 7 [(column_type) = "IPv6"];
		
		  // Layer 3 protocol (IPv4/IPv6/ARP/MPLS...)
		  uint32 Etype = 30 [(column_type) = "UInt16"];
		
		  // Layer 4 protocol
		  uint32 Proto = 20 [(column_type) = "UInt8"];
		
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
		  uint32 IPTos = 23 [(column_type) = "UInt8"];
		  uint32 ForwardingStatus = 24 [(column_type) = "UInt8"];
		  uint32 IPTTL = 25 [(column_type) = "UInt8"];
		  uint32 TCPFlags = 26 [(column_type) = "UInt8"];
		  uint32 IcmpType = 31 [(column_type) = "UInt8"];
		  uint32 IcmpCode = 32 [(column_type) = "UInt8"];
		  uint32 IPv6FlowLabel = 37;
		
		  // Fragments (IPv4/IPv6)
		  uint32 FragmentId = 35;
		  uint32 FragmentOffset = 36;
		
		  uint32 BiFlowDirection = 41 [(column_type) = "UInt8"];
		
		  // Autonomous system information
		  uint32 SrcAS = 14;
		  uint32 DstAS = 15;
		
		  bytes NextHop = 12 [(column_type) = "IPv6"];
		  uint32 NextHopAS = 13;
		
		  // Prefix size
		  uint32 SrcNet = 16 [(column_type) = "UInt8"];
		  uint32 DstNet = 17 [(column_type) = "UInt8"];
		
		  // IP encapsulation information
		  bool HasEncap = 43 [(column_skip) = true];
		  bytes SrcAddrEncap = 44 [(column_skip) = true];
		  bytes DstAddrEncap = 45 [(column_skip) = true];
		  uint32 ProtoEncap = 46 [(column_skip) = true];
		  uint32 EtypeEncap = 47 [(column_skip) = true];
		
		  uint32 IPTosEncap = 48 [(column_skip) = true];
		  uint32 IPTTLEncap = 49 [(column_skip) = true];
		  uint32 IPv6FlowLabelEncap = 50 [(column_skip) = true];
		  uint32 FragmentIdEncap = 51 [(column_skip) = true];
		  uint32 FragmentOffsetEncap = 52 [(column_skip) = true];
		
		  // MPLS information
		  bool HasMPLS = 53 [(column_skip) = true];
		  uint32 MPLSCount = 54 [(column_skip) = true];
		  uint32 MPLS1TTL = 55 [(column_skip) = true]; // First TTL
		  uint32 MPLS1Label = 56 [(column_skip) = true]; // First Label
		  uint32 MPLS2TTL = 57 [(column_skip) = true]; // Second TTL
		  uint32 MPLS2Label = 58 [(column_skip) = true]; // Second Label
		  uint32 MPLS3TTL = 59 [(column_skip) = true]; // Third TTL
		  uint32 MPLS3Label = 60 [(column_skip) = true]; // Third Label
		  uint32 MPLSLastTTL = 61 [(column_skip) = true]; // Last TTL
		  uint32 MPLSLastLabel = 62 [(column_skip) = true]; // Last Label
		
		  // PPP information
		  bool HasPPP = 63 [(column_skip) = true];
		  uint32 PPPAddressControl = 64 [(column_skip) = true];
		
		  // Custom fields: start after ID 1000:
		  // uint32 MyCustomField = 1000;
		}
		"""#
