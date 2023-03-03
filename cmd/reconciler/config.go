package main

import (
	"fmt"
	"github.com/huandu/go-sqlbuilder"
	"sort"
	"strings"
)

// Function contains all information to create or benchmark a UDF inside Clickhouse
type Function struct {
	Name      string   `json:"name"`
	Arguments []string `json:"arguments"`
	Query     string   `json:"query"`
}

func (f *Function) CreateQuery() string {
	return fmt.Sprintf("CREATE FUNCTION %s AS (%s) -> %s", f.Name, strings.Join(f.Arguments, ", "), f.Query)
}

func (f *Function) CreateOrReplaceQuery() string {
	return fmt.Sprintf("CREATE OR REPLACE FUNCTION %s AS (%s) -> %s", f.Name, strings.Join(f.Arguments, ", "), f.Query)
}

// MaterializedView contains all information to create a MaterializedView inside Clickhouse
// It also allows to benchmark the select statement inside the MV
type MaterializedView struct {
	Name  string `json:"name"`
	To    string `json:"to"`
	From  string `json:"from"`
	Query string `json:"query"`
}

func (mv MaterializedView) DropQuery(database string) string {
	return fmt.Sprintf("DROP VIEW %s.%s", database, mv.Name)
}

func (mv MaterializedView) SelectQuery(database string) string {
	return strings.Replace(mv.Query, "%%from%%", database+"."+mv.From, 1)
}

func (mv MaterializedView) CreateQuery(database string) string {
	s := fmt.Sprintf("CREATE MATERIALIZED VIEW %s TO %s AS %s", mv.Name, mv.To, mv.Query)
	s = strings.Replace(s, "%%from%%", database+"."+mv.From, 1)
	return s
}

type Settings map[string]any

func (s Settings) String() string {
	var settings []string
	for k, v := range s {
		switch v.(type) {
		case int:
			settings = append(settings, fmt.Sprintf("%s = %d", k, v))
		case float64:
			settings = append(settings, fmt.Sprintf("%s = %.0f", k, v))
		case string:
			settings = append(settings, fmt.Sprintf("%s = %s", k, QuoteSingleQuote(v.(string))))
		default:
			settings = append(settings, fmt.Sprintf("%s = %s", k, v))
		}
	}

	// clickhouse sorts the settings internally
	sort.Strings(settings)

	return strings.Join(settings, ", ")
}

// Table contains the Name, the Type, additional Settings and
// a reference to a Message inside the Protobuf file
type Table struct {
	Name     string   `json:"name"`
	Schema   string   `json:"schema"`
	Engine   string   `json:"engine"`
	Settings Settings `json:"settings"`
}

func (t Table) CreateQuery(database string) (string, error) {
	builder := sqlbuilder.
		CreateTable(database + "." + t.Name)

	if err := loadTableSchema(t.Schema, builder); err != nil {
		return "", err
	}

	builder.SQL("ENGINE = " + t.Engine)

	if len(t.Settings) != 0 {
		builder.SQL("SETTINGS " + t.Settings.String())
	}

	return builder.String(), nil
}

func (t Table) DropQuery(database string) string {
	return fmt.Sprintf("DROP TABLE %s.%s", database, t.Name)
}

type Config struct {
	Database          string             `json:"database"`
	Functions         []Function         `json:"functions"`
	MaterializedViews []MaterializedView `json:"materialized_views"`
	SourceTables      []Table            `json:"source_tables"`
}
