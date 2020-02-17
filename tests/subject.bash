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

# Executing for the first time should create the note .
SUBJECT_FILE1=$($BIN "My Subject")
# File should be created for us.
[[ ! -f "$SUBJECT_FILE1" ]] && fail "file not created"
# Check correct path.
[[ "$SUBJECT_FILE1" != "$NOTES_DIR/subject/my_subject.md" ]] && fail "incorrect file location"
# Check if the correct heading is created.
[[ "$(cat "$SUBJECT_FILE1")" != "# My Subject" ]] && fail "unexpected file contents"
# Expect the initial commit and the commit to add the daily file.
[[ $(cd $NOTES_DIR && git rev-list --all --count) != "2" ]] && fail "Incorrect # commits created"
# TODO: test automatic pushing.

# The subject is case-insensitive.
SUBJECT_FILE2=$($BIN "my subject")
[[ "$SUBJECT_FILE2" != "$SUBJECT_FILE1" ]] && fail "different file location"
# Didn't change the note, so no changes, thus no commit.
[[ $(cd $NOTES_DIR && git rev-list --all --count) != "2" ]] && fail "Incorrect # commits created"

# Make some change.
echo "Some note" >> "$SUBJECT_FILE1"
# We can use the subject command and it should never overwrite external changes.
SUBJECT_FILE3=$($BIN subject "my subject")
[[ "$SUBJECT_FILE3" != "$SUBJECT_FILE1" ]] && fail "different file location"
# We changed the note above.
[[ $(cd $NOTES_DIR && git rev-list --all --count) != "3" ]] && fail "Incorrect # commits created"
# TODO: test automatic pushing.

# Check final file contents.
[[ "$(cat "$SUBJECT_FILE1")" != "$(printf "# My Subject\n\n\nSome note")" ]] && fail "unexpected final file contents"

# Cleanup.
rm -rf "$NOTES_DIR"
