package main

import (
	"context"
	"flag"
	"log"
	"os"
	"os/signal"
	"sync"
	"time"

	"github.com/sirupsen/logrus"

	"github.com/netsampler/goflow2/format"
	"github.com/netsampler/goflow2/transport"
	_ "github.com/netsampler/goflow2/transport/kafka"
)

var (
	Interfaces = flag.String("iface", "", "which interface to use in the following format: RX_NAME:TX_NAME,RX_NAME:TX_NAME")
	SampleRate = flag.Int("samplerate", 1000, "the samplerate to use")
	LogLevel   = flag.String("loglevel", "info", "Log level")
)

func main() {
	flag.Parse()

	lvl, _ := logrus.ParseLevel(*LogLevel)
	logrus.SetLevel(lvl)

	tapPairs := loadConfig()

	ctx := context.Background()
	transporter, err := transport.FindTransport(ctx, "kafka")
	if err != nil {
		log.Fatal(err)
	}
	defer transporter.Close(ctx)

	fmt, err := format.FindFormat(ctx, "pb")
	if err != nil {
		log.Fatal(err)
	}

	for _, tp := range tapPairs {
		if err := tp.RX.Open(); err != nil {
			logrus.Fatalf("opening interface %q: %v", tp.RX.name, err)
		}

		if err := tp.TX.Open(); err != nil {
			logrus.Fatalf("opening interface %q: %v", tp.TX.name, err)
		}
	}

	var wg sync.WaitGroup
	ctx, cancelFunc := context.WithCancel(context.Background())
	for _, tp := range tapPairs {
		wg.Add(1)
		go tp.RX.Run(ctx, &wg, fmt, transporter)

		wg.Add(1)
		go tp.TX.Run(ctx, &wg, fmt, transporter)
	}

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)

	<-c
	logrus.Println("Got Interrupt. Exiting...")
	cancelFunc()

	logrus.Println("Waiting a maxiumum of 10 Seconds for goroutines to shutdown")
	timeout, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	go func() {
		wg.Wait()
		cancel()
	}()

	defer cancel()
	<-timeout.Done()
}
