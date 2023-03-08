package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/ClickHouse/clickhouse-go/v2"
	"github.com/emicklei/proto"
	"github.com/huandu/go-sqlbuilder"
	"log"
	"os"
	"strings"
	"time"
)

var (
	cfg    = flag.String("config", "config.json", "The config file to use")
	dbHost = mustEnv("DB_HOST")
	dbUser = mustEnv("DB_USER")
	dbPass = mustEnv("DB_PASS")
)

func loadConfig() (*Config, error) {
	cfgFile, err := os.Open(*cfg)
	if err != nil {
		return nil, err
	}
	defer cfgFile.Close()

	var cfg Config
	d := json.NewDecoder(cfgFile)
	d.DisallowUnknownFields()
	if err := d.Decode(&cfg); err != nil {
		return nil, err
	}

	return &cfg, nil
}

func mustEnv(name string) string {
	v, found := os.LookupEnv(name)
	if !found {
		log.Fatalf("missing env: %s", name)
	}

	return v
}

func main() {
	flag.Parse()

	cfg, err := loadConfig()
	if err != nil {
		log.Fatalf("loading config: %v", err)
	}

	conn, err := clickhouse.Open(&clickhouse.Options{
		Addr: []string{dbHost},
		Auth: clickhouse.Auth{
			Database: cfg.Database,
			Username: dbUser,
			Password: dbPass,
		},
	})
	if err != nil {
		log.Fatal(err)
	}

	if err := conn.Ping(context.Background()); err != nil {
		log.Fatal(err)
	}

	r := &Reconciler{
		conn: conn,
		cfg:  cfg,
	}

	for {
		if err := r.Reconcile(); err != nil {
			log.Println(err)
		}
		log.Println("reconcile done. sleeping for some time")
		time.Sleep(1 * time.Minute)
	}
}

func loadTableSchema(schema string, builder *sqlbuilder.CreateTableBuilder) error {
	n := strings.SplitN(schema, ":", 2)
	if len(n) != 2 {
		return fmt.Errorf("invalid source table schema: %v", schema)
	}

	path, msgName := n[0], n[1]
	f, err := os.Open(path)
	if err != nil {
		return err
	}
	defer f.Close()

	parser := proto.NewParser(f)
	definition, err := parser.Parse()
	if err != nil {
		return err
	}

	cv := &clickhouseVisitor{
		enumTypes: make(map[string]map[string]int),
		builder:   builder,
	}

	var msg *proto.Message
	proto.Walk(definition,
		proto.WithEnum(func(e *proto.Enum) {
			e.Accept(cv)
		}),
		proto.WithMessage(func(message *proto.Message) {
			if message.Name == msgName {
				msg = message
			}
		}))
	if msg == nil {
		return fmt.Errorf("can't find message inside %q: %v", path, msgName)
	}

	// we have to evaluate the message after the proto.Walk
	// else it's not guaranteed that all enums are discovered
	msg.Accept(cv)

	return nil
}
