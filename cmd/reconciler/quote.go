package main

import _ "unsafe"

// we use unsafe and go:linkname because copying the whole strconv package would be very cluttering
//
//go:linkname quoteWith strconv.quoteWith
func quoteWith(s string, quote byte, ASCIIonly, graphicOnly bool) string

// QuoteSingleQuote has the same functionality as strconv.Quote but uses single quotes
func QuoteSingleQuote(s string) string {
	return quoteWith(s, '\'', false, false)
}
