package main

import (
	"fmt"
	"github.com/emicklei/proto"
	"github.com/huandu/go-sqlbuilder"
	"log"
	"math"
	"sort"
	"strings"
)

type clickhouseVisitor struct {
	proto.NoopVisitor
	enumTypes map[string]map[string]int
	builder   *sqlbuilder.CreateTableBuilder
}

func (c *clickhouseVisitor) VisitMessage(m *proto.Message) {
	for _, v := range m.Elements {
		v.Accept(c)
	}
}

func (c *clickhouseVisitor) VisitNormalField(i *proto.NormalField) {
	columnName := i.Name
	columnType := c.ToColumnType(i.Type)

	for _, option := range i.Options {
		switch option.Name {
		case "(column_type)":
			columnType = option.Constant.Source
		case "(column_name)":
			columnName = option.Constant.Source
		case "(column_skip)":
			// just exit the visitor and ignore the rest of the logic
			return
		default:
			log.Printf("unknown option %q on %q! Skipping!", option.Name, i.Name)
		}
	}

	c.builder.Define(columnName, columnType)
}

func (c *clickhouseVisitor) VisitEnumField(i *proto.EnumField) {
	c.enumTypes[i.Parent.(*proto.Enum).Name][i.Name] = i.Integer
}

func (c *clickhouseVisitor) VisitEnum(e *proto.Enum) {
	c.enumTypes[e.Name] = make(map[string]int)
	for _, v := range e.Elements {
		v.Accept(c)
	}
}

type enumOption struct {
	value int
	name  string
}

func (e enumOption) String() string {
	return fmt.Sprintf("%s = %d", QuoteSingleQuote(e.name), e.value)
}

func (c *clickhouseVisitor) ToColumnType(t string) string {
	if enum, found := c.enumTypes[t]; found {
		var enumOptions []enumOption

		for s, i := range enum {
			enumOptions = append(enumOptions, enumOption{
				value: i,
				name:  s,
			})
		}

		size := int(math.Log2(float64(len(enumOptions))))
		switch {
		case size <= 8:
			size = 8
		case size <= 16:
			size = 16
		default:
			size = 0
		}

		t := fmt.Sprintf("Enum%d", size)
		if size == 0 {
			t = "Enum"
		}

		// Enums are sorted inside clickhouse
		sort.SliceStable(enumOptions, func(i, j int) bool {
			return enumOptions[i].value < enumOptions[j].value
		})

		var enumOptionStrings []string
		for _, option := range enumOptions {
			enumOptionStrings = append(enumOptionStrings, option.String())
		}

		return fmt.Sprintf("%s(%s)", t, strings.Join(enumOptionStrings, ", "))
	}

	switch t {
	case "int32":
		return "Int32"
	case "uint32":
		return "UInt32"
	case "int64":
		return "Int64"
	case "uint64":
		return "UInt64"
	case "bytes":
		return "String"
	case "bool":
		return "Bool"
	case "string":
		return "String"
	default:
		panic("type not implemented: " + t)
	}
}
