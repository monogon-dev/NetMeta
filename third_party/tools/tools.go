//go:build tools

package tools

// Static imports for command-line dependencies we build from source.

import (
	_ "cuelang.org/go/cmd/cue"
	_ "github.com/bazelbuild/bazelisk"
	_ "github.com/pressly/goose/cmd/goose"
)
