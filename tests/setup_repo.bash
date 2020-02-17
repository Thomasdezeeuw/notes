#!/bin/bash

set -eu

BIN="./note.bash"

# Temporary directory for our test notes.
export NOTES_DIR=$(mktemp -d)
# No-op editor.
export EDITOR="true"

# Executing for the first time should create the repo.
$BIN
if [[ ! -f "$NOTES_DIR/.git/HEAD" ]]; then
	echo "Failed to create git repo"
	exit 1
fi

# Executing a second time should be ok.
$BIN
if [[ ! -f "$NOTES_DIR/.git/HEAD" ]]; then
	echo "Failed to create git repo"
	exit 1
fi

# Cleanup.
rm -rf "$NOTES_DIR"
