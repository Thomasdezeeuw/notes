#!/bin/bash

# Copyright 2018 Thomas de Zeeuw
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license <LICENSE-MIT
# or http://opensource.org/licenses/MIT>, at your option. This file may not be
# used, copied, modified, or distributed except according to those terms.

set -eu

NOTES_AUTO_SYNC=${NOTES_AUTO_SYNC:-"false"}
NOTES_ROOT=${NOTES_ROOT:-"$HOME/.notes"}
EDTIOR=${EDITOR:-vim}

# Create the git repo, if needed.
setup() {
	mkdir -p "$NOTES_ROOT"
	if [[ ! -f "$NOTES_ROOT/.git/HEAD" ]]; then
		git init --quiet "$NOTES_ROOT"
	fi
}

help() {
	echo "Usage:
notes [options]

	--help            Show this help message.

ENVIRONMENT VARIABLES

	\$EDITOR          The editor with which to edit lists, defaults to vim.
	\$NOTES_ROOT      The root directory which contains all notes, defaults to '~/.notes'.
	\$NOTES_AUTO_SYNC If this is set to 'true', or '1', notes will sync after each edit, defaults to false."
}

open() {
	FILE="$NOTES_ROOT/$(date '+%Y.%V.md')"

	# Setup a skeleton if the file doesn't exists.
	if [[ ! -f "$FILE" ]]; then
		printf "# Weekly notes" >> "$FILE"
	fi

	# Create a section for new notes.
	DATE=$(date '+%A %B %d %Y %H:%M')
	printf "\n\n## $DATE\n\n\n" >> "$FILE"

	# Special editor options.
	EDITOR_OPTS=""
	if [[ "$EDITOR" == "vim" ]]; then
		# Go to the end of the file when opened.
		EDITOR_OPTS="+"
	fi

	# Open the users editor to allow them to edit the notes.
	$EDITOR $EDITOR_OPTS "$FILE"

	# Commit the changes.
	COMMIT_MSG="Update notes for $DATE"
	(cd "$NOTES_ROOT" &&
		git add "$FILE" &&
		git commit --quiet --message="$COMMIT_MSG" 1>/dev/null || true)

	# Automatically sync the notes, if that is required.
	if [[ "$NOTES_AUTO_SYNC" == "true" || "$NOTES_AUTO_SYNC" == "1" ]]; then
		(cd "$NOTES_ROOT" && git push --quiet)
	fi
}

setup

open
