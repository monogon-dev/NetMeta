package main

import (
	"context"
	"github.com/netsampler/goflow2/format"
	flowmessage "github.com/netsampler/goflow2/pb"
	"github.com/netsampler/goflow2/transport"
	"log"
	"strings"
	"sync"

	"github.com/google/gopacket"
	"github.com/google/gopacket/afpacket"
	"github.com/google/gopacket/layers"
	"github.com/prometheus/procfs/sysfs"
	"github.com/sirupsen/logrus"
)

type tapInterface struct {
	name     string
	sysIface sysfs.NetClassIface
	packet   *afpacket.TPacket
	pair     *tapPair
}

type tapPair struct {
	RX *tapInterface
	TX *tapInterface
}

type netClasses map[string]sysfs.NetClassIface

func newNetClasses() (netClasses, error) {
	fs, err := sysfs.NewFS("/sys")
	if err != nil {
		return nil, err
	}

	class, err := fs.NetClass()
	if err != nil {
		return nil, err
	}

	ifaceClasses := make(netClasses)
	for _, c := range class {
		ifaceClasses[c.Name] = c
	}

	return ifaceClasses, nil
}

func (nc netClasses) getNetClass(name string) sysfs.NetClassIface {
	class, ok := nc[name]
	if !ok {
		logrus.Fatalf("cant find interface: %q", name)
	}
	return class
}

func loadConfig() []*tapPair {
	if len(*Interfaces) == 0 {
		logrus.Fatal("please provide interface pairs")
	}

	netClasses, err := newNetClasses()
	if err != nil {
		logrus.Fatalf("loading net class info: %v", err)
	}

	var tapPairs []*tapPair
	for _, v := range strings.Split(*Interfaces, ",") {
		if !strings.Contains(v, ":") {
			logrus.Fatalf("invalid interface pair given: %q", v)
		}

		split := strings.Split(v, ":")
		rxName, txName := split[0], split[1]
		t := &tapPair{
			RX: &tapInterface{
				name:     rxName,
				sysIface: netClasses.getNetClass(rxName),
			},
			TX: &tapInterface{
				name:     txName,
				sysIface: netClasses.getNetClass(txName),
			},
		}
		t.RX.pair = t
		t.TX.pair = t

		logrus.Printf("Interface %q: %d", t.RX.sysIface.Name, *t.RX.sysIface.IfIndex)
		logrus.Printf("Interface %q: %d", t.TX.sysIface.Name, *t.TX.sysIface.IfIndex)

		tapPairs = append(tapPairs, t)
	}

	return tapPairs
}

func (ti *tapInterface) Open() error {
	tPacket, err := afpacket.NewTPacket(
		afpacket.OptInterface(ti.name),
		afpacket.SocketRaw,
		afpacket.TPacketVersion3)
	if err != nil {
		return err
	}

	if err := tPacket.InitSocketStats(); err != nil {
		return err
	}

	ti.packet = tPacket
	return nil
}

func (ti *tapInterface) Run(ctx context.Context, wg *sync.WaitGroup, format *format.Format, transport *transport.Transport) {
	defer wg.Done()
	defer func() {
		ti.packet.Close()
		logrus.Printf("Stopping Interface %q", ti.name)
	}()

	for seqNum := 0; true; seqNum++ {
		select {
		case <-ctx.Done():
			return
		default:
		}

		data, ci, err := ti.packet.ZeroCopyReadPacketData()
		if err != nil {
			log.Panic(err)
		}

		if seqNum%*SampleRate != 0 {
			continue
		}

		isRX := ti.pair.RX == ti
		var flowDirection uint32
		var inIf, outIf uint32
		if isRX {
			flowDirection = 0 // Inbound traffic because this is a RX Mirror interface
			inIf = uint32(*ti.sysIface.IfIndex)
		} else {
			flowDirection = 1 // Outbound traffic because this is a TX Mirror interface
			outIf = uint32(*ti.sysIface.IfIndex)
		}

		info := readFrameInfo(gopacket.NewPacket(data, layers.LayerTypeEthernet, gopacket.Default))
		msg := &flowmessage.FlowMessage{
			Type:           flowmessage.FlowMessage_SFLOW_5,
			TimeReceived:   uint64(ci.Timestamp.Unix()),
			SequenceNum:    uint32(seqNum),
			SamplingRate:   uint64(*SampleRate),
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

		key, data, err := format.Format(msg)
		if err != nil {
			log.Println(err)
			continue
		}

		if err := transport.Send(key, data); err != nil {
			log.Println(err)
			continue
		}
	}
}
