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

# Executing for the first time should create the daily note file.
DAILY_FILE1=$($BIN)
# File should be created for us.
[[ ! -f "$DAILY_FILE1" ]] && fail "daily file not created"
# Check correct path.
[[ "$DAILY_FILE1" != "$NOTES_DIR/daily/$(date '+%Y-%m-%d').md" ]] && fail "incorrect file location"
# Check if the correct heading is created.
[[ "$(cat "$DAILY_FILE1")" != "# $(date '+%A %B %d, %Y')" ]] && fail "unexpected file contents"
# Expect the initial commit and the commit to add the daily file.
[[ $(cd $NOTES_DIR && git rev-list --all --count) != "2" ]] && fail "Incorrect # commits created"
# TODO: test automatic pushing.

# Second run should re-use the same file.
DAILY_FILE2=$($BIN)
[[ "$DAILY_FILE2" != "$DAILY_FILE1" ]] && fail "different file location"
# Didn't change the note, so no changes, thus no commit.
[[ $(cd $NOTES_DIR && git rev-list --all --count) != "2" ]] && fail "Incorrect # commits created"

# Make some change.
echo "Some note" >> "$DAILY_FILE1"
# Never overwrite external changes.
DAILY_FILE3=$($BIN)
[[ "$DAILY_FILE3" != "$DAILY_FILE1" ]] && fail "different file location"
# We changed the note above.
[[ $(cd $NOTES_DIR && git rev-list --all --count) != "3" ]] && fail "Incorrect # commits created"
# TODO: test automatic pushing.

# Check the file contents.
[[ "$(cat "$DAILY_FILE1")" != "$(printf "# $(date '+%A %B %d, %Y')\n\n\nSome note")" ]] && fail "unexpected final file contents"

# Cleanup.
rm -rf "$NOTES_DIR"
