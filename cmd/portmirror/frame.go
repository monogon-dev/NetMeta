package main

import (
	"net"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
)

func macToUint64(mac net.HardwareAddr) (u uint64) {
	return uint64(mac[0])<<40 | uint64(mac[1])<<32 | (uint64(mac[2])<<24 | uint64(mac[3])<<16 | uint64(mac[4])<<8 | uint64(mac[5]))
}

type frameInfo struct {
	EthernetType uint32
	SrcMAC       net.HardwareAddr
	DstMAC       net.HardwareAddr

	Protocol  uint32
	SrcIP     net.IP
	DstIP     net.IP
	IPTOS     uint8
	IPTTL     uint8
	FlowLabel uint32

	TCPFlags uint32
	SrcPort  uint32
	DstPort  uint32
}

func readFrameInfo(packet gopacket.Packet) (info frameInfo) {
	for _, layer := range packet.Layers() {
		switch layer.(type) {
		case *layers.Ethernet:
			info.EthernetType = uint32(layer.(*layers.Ethernet).EthernetType)
			info.SrcMAC = layer.(*layers.Ethernet).SrcMAC
			info.DstMAC = layer.(*layers.Ethernet).DstMAC

		case *layers.IPv4:
			info.Protocol = uint32(layer.(*layers.IPv4).Protocol)
			info.SrcIP = layer.(*layers.IPv4).SrcIP
			info.DstIP = layer.(*layers.IPv4).DstIP
			info.IPTOS = layer.(*layers.IPv4).TOS
			info.IPTTL = layer.(*layers.IPv4).TTL

		case *layers.IPv6:
			info.Protocol = uint32(layer.(*layers.IPv6).NextHeader)
			info.SrcIP = layer.(*layers.IPv6).SrcIP
			info.DstIP = layer.(*layers.IPv6).DstIP
			info.FlowLabel = layer.(*layers.IPv6).FlowLabel

		case *layers.TCP:
			info.SrcPort = uint32(layer.(*layers.TCP).SrcPort)
			info.DstPort = uint32(layer.(*layers.TCP).DstPort)
			info.TCPFlags = uint32(layer.(*layers.TCP).Contents[13])

		case *layers.UDP:
			info.SrcPort = uint32(layer.(*layers.UDP).SrcPort)
			info.DstPort = uint32(layer.(*layers.UDP).DstPort)
		}
	}

	return
}
