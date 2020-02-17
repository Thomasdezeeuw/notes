#!/bin/bash

set -eu

BIN="./note.bash"

# Temporary directory for our test notes.
export NOTES_DIR=$(mktemp -d)
# No-op editor.
export EDITOR="echo"

fail() {
	echo "$1"
	exit 1
}

# Create some subject files.
FILE1=$($BIN "my subject")
FILE2=$($BIN "my subject2")
FILE3=$($BIN "my subject3")
FILE4=$($BIN "Lions")

RESULTS1=$($BIN search "my subject" | sort) # Output is not sorted, so we sort it.
[[ "$RESULTS1" != "$(printf "$FILE1\n$FILE2\n$FILE3")" ]] && fail "incorrect search results"

# Search is case in-sensitive.
RESULTS2=$($BIN search "lions")
[[ "$RESULTS2" != "$(printf "$FILE4")" ]] && fail "incorrect search results"

# Insert our fake vim (that echos the arguments).
RESULTS3=$(PATH="$(cd `dirname $0` && pwd -P)/bin:$PATH" EDITOR="vim" $BIN search "lions")
[[ "$RESULTS3" != "$(printf "+/lions\\c -p $FILE4")" ]] && fail "incorrect Vim options"

# Cleanup.
rm -rf "$NOTES_DIR"
