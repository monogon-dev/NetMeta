package main

import (
	"fmt"
	"log"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/ast"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/load"
)

var skeletonOptions = []cue.Option{
	cue.Attributes(true),
	cue.Concrete(false),
	cue.Definitions(false),
	cue.DisallowCycles(true),
	cue.Docs(true),
	cue.Hidden(true),
	cue.Optional(true),
}

func main() {
	ctx := cuecontext.New()
	bis := load.Instances([]string{}, &load.Config{Dir: "../.."})
	for _, bi := range bis {
		if bi.Err != nil {
			log.Fatal("Error during loading", "entrypoints", "error", bi.Err)
		}
		orgCue := ctx.BuildInstance(bi)
		orgNode := orgCue.Syntax(skeletonOptions...)
		beforeNode := func(v ast.Node) bool {
			return true
		}

		debugNode := func(v ast.Node) {
			for _, comment := range ast.Comments(v) {
				for _, lines := range comment.List {
					fmt.Println("debugging ast", "comment", lines.Text, "name", ast.Name(v))
				}
			}
		}

		ast.Walk(orgNode, beforeNode, debugNode)
	}
}
