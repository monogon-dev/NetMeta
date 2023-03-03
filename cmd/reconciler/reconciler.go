package main

import (
	"context"
	"database/sql"
	"fmt"
	"github.com/ClickHouse/clickhouse-go/v2"
	"log"
)

type Reconciler struct {
	conn clickhouse.Conn
	cfg  *Config
}

func (r *Reconciler) Reconcile() error {
	for _, table := range r.cfg.SourceTables {
		if err := r.reconcileTable(table); err != nil {
			return err
		}
	}

	for _, view := range r.cfg.MaterializedViews {
		if err := r.reconcileMaterializedView(view); err != nil {
			return err
		}
	}

	for _, function := range r.cfg.Functions {
		if err := r.reconcileFunction(function); err != nil {
			return err
		}
	}

	return nil
}

func (r *Reconciler) reconcileTable(t Table) error {
	currentQuery, err := r.fetchTable(t.Name)
	if err != nil && err != sql.ErrNoRows {
		return err
	}

	createQuery, err := t.CreateQuery(r.cfg.Database)
	if err != nil {
		return err
	}

	if currentQuery != "" {
		// fetchTable returns the CREATE TABLE statement
		equal, err := r.isEqual(createQuery, currentQuery)
		if err != nil {
			return err
		}

		// current table is equal -> skip
		if equal {
			log.Printf("table %q is equal: skipping", t.Name)
			return nil
		}

		log.Printf("table %q is not equal: dropping", t.Name)
		if err := r.conn.Exec(context.Background(), t.DropQuery(r.cfg.Database)); err != nil {
			return err
		}
	}

	log.Printf("table %q is missing: creating", t.Name)
	// create missing view
	return r.conn.Exec(context.Background(), createQuery)
}

func (r *Reconciler) reconcileMaterializedView(mv MaterializedView) error {
	currentQuery, err := r.fetchMaterializedView(mv.Name)
	if err != nil && err != sql.ErrNoRows {
		return err
	}

	if currentQuery != "" {
		// fetchMaterializedView returns the SELECT part of the materialized view
		equal, err := r.isEqual(mv.SelectQuery(r.cfg.Database), currentQuery)
		if err != nil {
			return err
		}

		// current mv is equal -> skip
		if equal {
			log.Printf("materializedview %q is equal: skipping", mv.Name)
			return nil
		}

		log.Printf("materializedview %q is not equal: dropping", mv.Name)
		if err := r.conn.Exec(context.Background(), mv.DropQuery(r.cfg.Database)); err != nil {
			return err
		}
	}

	log.Printf("materializedview %q is missing: creating", mv.Name)
	// create missing view
	return r.conn.Exec(context.Background(), mv.CreateQuery(r.cfg.Database))
}

func (r *Reconciler) reconcileFunction(f Function) error {
	currentQuery, err := r.fetchFunction(f.Name)
	if err != nil && err != sql.ErrNoRows {
		return err
	}

	if currentQuery != "" {
		// fetchFunction returns the original CREATE FUNCTION statement
		equal, err := r.isEqual(f.CreateQuery(), currentQuery)
		if err != nil {
			return err
		}

		// current function is equal -> skip
		if equal {
			log.Printf("function %q is equal: skipping", f.Name)
			return nil
		}

		log.Printf("function %q is not equal: replacing", f.Name)
		// replace function
		return r.conn.Exec(context.Background(), f.CreateOrReplaceQuery())
	}

	// create missing function
	return r.conn.Exec(context.Background(), f.CreateQuery())
}

func (r *Reconciler) fetchTable(name string) (string, error) {
	row := r.conn.QueryRow(context.Background(),
		"SELECT create_table_query FROM system.tables WHERE database = ? AND name = ?",
		r.cfg.Database, name)
	if err := row.Err(); err != nil {
		return "", err
	}

	var createTableQuery string
	if err := row.Scan(&createTableQuery); err != nil {
		return "", err
	}

	return createTableQuery, nil
}

func (r *Reconciler) fetchFunction(name string) (string, error) {
	row := r.conn.QueryRow(context.Background(),
		"SELECT create_query FROM system.functions WHERE name = ?",
		name)
	if err := row.Err(); err != nil {
		return "", err
	}

	var createQuery string
	if err := row.Scan(&createQuery); err != nil {
		return "", err
	}

	return createQuery, nil
}

func (r *Reconciler) fetchMaterializedView(name string) (string, error) {
	row := r.conn.QueryRow(context.Background(),
		"SELECT as_select FROM system.tables WHERE database = ? AND name = ?",
		"default", name)
	if err := row.Err(); err != nil {
		return "", err
	}

	var asSelect string
	if err := row.Scan(&asSelect); err != nil {
		return "", err
	}

	return asSelect, nil
}

func (r *Reconciler) formatQuery(query string) (string, error) {
	row := r.conn.QueryRow(context.Background(), "SELECT formatQuery(?)", query)
	if err := row.Err(); err != nil {
		return "", err
	}

	var result string
	if err := row.Scan(&result); err != nil {
		return "", err
	}

	return result, nil
}

func (r *Reconciler) isEqual(want, is string) (bool, error) {
	if want == "" {
		return false, fmt.Errorf("missing %q", "want")
	}
	if is == "" {
		return false, fmt.Errorf("missing %q", "is")
	}

	var err error
	want, err = r.formatQuery(want)
	if err != nil {
		return false, fmt.Errorf("formatting %q: %v", "want", err)
	}

	is, err = r.formatQuery(is)
	if err != nil {
		return false, fmt.Errorf("formatting %q: %v", "is", err)
	}

	return want == is, nil
}
