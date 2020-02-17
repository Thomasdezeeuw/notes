#!/bin/bash

set -eu

BIN="./note.bash"

# Temporary directory for our test notes, just to be sure.
export NOTES_DIR=$(mktemp -d)

contains_usage() {
	local input="$1"
	echo "$input" | grep "DESCRIPTION" > /dev/null
	echo "$input" | grep "OPTIONS" > /dev/null
	echo "$input" | grep "COMMANDS" > /dev/null
	echo "$input" | grep "ENVIRONMENT VARIABLES" > /dev/null
}

contains_usage "$($BIN --help)" || (echo "missing --help usage" && exit 1)
contains_usage "$($BIN help)" || (echo "missing help usage" && exit 1)

# Cleanup.
rm -rf "$NOTES_DIR"
