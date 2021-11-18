package main

import (
	"context"
	"flag"
	"os"
	"os/signal"
	"sync"
	"time"

	"github.com/sirupsen/logrus"

	"github.com/cloudflare/goflow/v3/transport"
)

var (
	interfaces  string
	sampleRate  int
	logLevel    string
	fixedLength bool
	workerCount int
	fanoutBase  int
)

func init() {
	flag.StringVar(&interfaces, "iface", "", "which interface to use in the following format: RX_NAME:TX_NAME,RX_NAME:TX_NAME")
	flag.IntVar(&sampleRate, "samplerate", 1000, "the samplerate to use")
	flag.StringVar(&logLevel, "loglevel", "info", "Log level")
	flag.BoolVar(&fixedLength, "proto.fixedlen", false, "enable fixed length protobuf")
	flag.IntVar(&workerCount, "workercount", 8, "number of goroutines to spawn per interface")
	flag.IntVar(&fanoutBase, "fanoutBase", 42, "fanout group base id which gets added to the interface index to form the fanout group id")
}

func main() {
	transport.RegisterFlags()
	flag.Parse()

	lvl, _ := logrus.ParseLevel(logLevel)
	logrus.SetLevel(lvl)

	tapPairs, err := loadConfig()
	if err != nil {
		logrus.Fatal(err)
	}

	kafkaState, err := transport.StartKafkaProducerFromArgs(logrus.StandardLogger())
	if err != nil {
		logrus.Fatal(err)
	}
	kafkaState.FixedLengthProto = fixedLength

	var startGroup, endGroup sync.WaitGroup
	startGroup.Add(workerCount * len(tapPairs) * 2)
	endGroup.Add(workerCount * len(tapPairs) * 2)

	ctx, cancelFunc := context.WithCancel(context.Background())
	for _, tp := range tapPairs {
		logrus.Infof("Starting workers on pair: RX: %q - TX: %q", tp.RX.name, tp.TX.name)
		for i := 0; i < workerCount; i++ {
			go tp.TX.Worker(ctx, &startGroup, &endGroup, kafkaState)
		}

		for i := 0; i < workerCount; i++ {
			go tp.RX.Worker(ctx, &startGroup, &endGroup, kafkaState)
		}
	}
	logrus.Infof("Waiting for workers to become ready...")
	startGroup.Wait()
	logrus.Infof("Lets go!")

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)

	<-c
	logrus.Println("Got Interrupt. Exiting...")
	cancelFunc()

	logrus.Println("Waiting a maxiumum of 10 Seconds for goroutines to shutdown")
	timeout, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	go func() {
		endGroup.Wait()
		cancel()
	}()

	defer cancel()
	<-timeout.Done()
}
