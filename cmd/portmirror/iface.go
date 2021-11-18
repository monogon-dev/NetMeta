package main

import (
	"context"
	"strings"
	"sync"
	"sync/atomic"

	flowprotob "github.com/cloudflare/goflow/v3/pb"
	"github.com/cloudflare/goflow/v3/transport"
	"github.com/google/gopacket"
	"github.com/google/gopacket/afpacket"
	"github.com/google/gopacket/layers"
	"github.com/sirupsen/logrus"
	"github.com/vishvananda/netlink"
)

type tapInterface struct {
	name    string
	ifIndex int
	isRX    bool
	counter uint64
}

type tapPair struct {
	RX *tapInterface
	TX *tapInterface
}

func loadConfig() []*tapPair {
	if len(interfaces) == 0 {
		logrus.Fatal("please provide interface pairs")
	}

	var tapPairs []*tapPair
	for _, v := range strings.Split(interfaces, ",") {
		if !strings.Contains(v, ":") {
			logrus.Fatalf("invalid interface pair given: %q", v)
		}

		split := strings.Split(v, ":")
		if len(split) != 2 {
			logrus.Fatal("invalid interface pair given: %q", v)
		}

		rxName, txName := split[0], split[1]
		rxLink, err := netlink.LinkByName(rxName)
		if err != nil {
			logrus.Fatalf("cant find interface: %q", rxName)
		}

		if err := netlink.SetPromiscOn(rxLink); err != nil {
			logrus.Fatalf("cant set promisc mode on interface: %q", rxName)
		}

		txLink, err := netlink.LinkByName(txName)
		if err != nil {
			logrus.Fatalf("cant find interface: %q", txName)
		}

		if err := netlink.SetPromiscOn(txLink); err != nil {
			logrus.Fatalf("cant set promisc mode on interface: %q", txName)
		}

		t := &tapPair{
			RX: &tapInterface{
				name:    rxName,
				isRX:    true,
				ifIndex: rxLink.Attrs().Index,
			},
			TX: &tapInterface{
				name:    txName,
				ifIndex: txLink.Attrs().Index,
			},
		}

		tapPairs = append(tapPairs, t)
	}

	return tapPairs
}

func (ti *tapInterface) Worker(ctx context.Context, startGroup *sync.WaitGroup, endGroup *sync.WaitGroup, kafkaState *transport.KafkaState) {
	defer endGroup.Done()

	handle, err := afpacket.NewTPacket(
		afpacket.OptInterface(ti.name),
		afpacket.SocketRaw,
		afpacket.TPacketVersion3,
	)
	if err != nil {
		logrus.Fatalf("opening interface %q: %v", ti.name, err)
	}

	// PACKET_FANOUT_CPU selects the socket based on the CPU that the packet arrived on.
	err = handle.SetFanout(afpacket.FanoutCPU, uint16(fanoutBase*ti.ifIndex))
	if err != nil {
		logrus.Fatalf("setting fanout on interface %q: %v", ti.name, err)
	}
	defer handle.Close()

	startGroup.Done()
	startGroup.Wait()

	var flowDirection uint32
	var inIf, outIf uint32
	if ti.isRX {
		flowDirection = 0 // Inbound traffic because this is a RX Mirror interface
		inIf = uint32(ti.ifIndex)
	} else {
		flowDirection = 1 // Outbound traffic because this is a TX Mirror interface
		outIf = uint32(ti.ifIndex)
	}

	for {
		select {
		case <-ctx.Done():
			return
		default:
		}

		data, ci, _ := handle.ZeroCopyReadPacketData()
		if atomic.AddUint64(&ti.counter, 1)%uint64(sampleRate) != 0 {
			continue
		}

		info := readFrameInfo(gopacket.NewPacket(data, layers.LayerTypeEthernet, gopacket.Default))
		msg := &flowprotob.FlowMessage{
			Type:           flowprotob.FlowMessage_SFLOW_5,
			TimeReceived:   uint64(ci.Timestamp.Unix()),
			SequenceNum:    info.SeqNum,
			SamplingRate:   uint64(sampleRate),
			FlowDirection:  flowDirection,
			SamplerAddress: []byte{127, 0, 0, 1},
			TimeFlowStart:  uint64(ci.Timestamp.Unix()),
			TimeFlowEnd:    uint64(ci.Timestamp.Unix()),
			Bytes:          uint64(ci.Length),
			Packets:        1,
			SrcAddr:        info.SrcIP,
			DstAddr:        info.DstIP,
			Etype:          info.EthernetType,
			Proto:          info.Protocol,
			SrcPort:        info.SrcPort,
			DstPort:        info.DstPort,
			InIf:           inIf,
			OutIf:          outIf,
			SrcMac:         macToUint64(info.SrcMAC),
			DstMac:         macToUint64(info.DstMAC),
			IPTos:          uint32(info.IPTOS),
			IPTTL:          uint32(info.IPTTL),
			TCPFlags:       info.TCPFlags,
			IPv6FlowLabel:  info.FlowLabel,
		}

		kafkaState.SendKafkaFlowMessage(msg)
	}
}
