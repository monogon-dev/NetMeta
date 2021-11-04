//go:build tools
// +build tools

package tools

// Static imports for command-line dependencies we build from source.

import (
	_ "cuelang.org/go/cmd/cue"
	_ "github.com/google/ko/cmd/ko"
)
