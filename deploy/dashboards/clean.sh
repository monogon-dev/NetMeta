#!/bin/bash

sed -i '/rawQuery/d' *.json
sed -i '/formattedQuery/d' *.json
sed -E -i 's/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*//' *.json
cue import --force
