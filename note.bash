#!/bin/bash

# Copyright 2018-2020 Thomas de Zeeuw
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license <LICENSE-MIT
# or http://opensource.org/licenses/MIT>, at your option. This file may not be
# used, copied, modified, or distributed except according to those terms.

set -eu

NOTES_AUTO_SYNC=${NOTES_AUTO_SYNC:-"false"}
NOTES_DIR=${NOTES_DIR:-"$HOME/.notes"}
EDITOR=${EDITOR:-vim}

# Initialise the notes repo, if needed.
setup() {
	if [[ ! -f "$NOTES_DIR/.git/HEAD" ]]; then
		git init --quiet "$NOTES_DIR"
		# Create directory structure.
		mkdir -p "$NOTES_DIR/daily" && touch "$NOTES_DIR/daily/.gitignore"
		mkdir -p "$NOTES_DIR/subject" && touch "$NOTES_DIR/subject/.gitignore"
		# Create initial commit.
		(cd "$NOTES_DIR" &&
			git add "daily/.gitignore" "subject/.gitignore" &&
			git commit --quiet --message="Create directory structure" 1>/dev/null)
	fi
}

help() {
	echo "note [options] [<command>] [<args>...]

DESCRIPTION
    note is a simple note keeper based on your preferred editor and git, using
    plain text files for the notes themselves and a git repo for
    synchronisation.

    By default note opens the daily note. The daily note is a note file for
    fleeting notes and is automatically created every day the first time the
    note command is called.

    Alternatively notes can be taking about a specific subject. This will
    contain all notes for a subject within a single file.

OPTIONS

    --help                Shows this help message.

COMMANDS

    help                  Shows this help message.
   [daily]                Opens the daily note for today.
   [subject] [\$name]      Opens the note on subject \$name. Note that subject
                          command is optional, i.e. \`note subject my_project\`
                          and \`note my_project\` are interrupted as the same
                          command.
    search [\$keyword...]  Search all notes, daily and subject notes, for
                          \$keyword(s).

ENVIRONMENT VARIABLES

    \$EDITOR               The editor with which to edit lists, defaults to vim.
    \$NOTES_DIR            The root directory which contains all notes, defaults
                          to '~/.notes'.
    \$NOTES_AUTO_SYNC      If this is set to 'true', or '1', notes will sync
                          after each edit, defaults to false.
"
}

open_daily() {
	local file="$NOTES_DIR/daily/$(date '+%Y-%m-%d').md"
	open_file "$file" "# $(date '+%A %B %d, %Y')\n\n\n"
}

open_subject() {
	local subject="$1"
	local file=$(echo "$subject" | tr '[:upper:]' '[:lower:]')
	file="$NOTES_DIR/subject/${file// /_}.md"
	open_file "$file" "# $subject\n\n\n"
}

open_file() {
	local file="$1"
	local heading="$2"

	# Add the heading if the file doesn't exists.
	if [[ ! -f "$file" ]]; then
		printf "$heading" >> "$file"
	fi

	# Special editor options.
	local editor_opts=""
	if [[ "$EDITOR" == "vim" ]]; then
		# Go to the end of the file when opened.
		editor_opts="+"
	fi

	# Open the users editor to allow them to edit the notes.
	$EDITOR $editor_opts "$file"

	sync "$file"
}

sync() {
	# Local path to the file.
	local file=${1/$NOTES_DIR\//}

	# Commit the changes.
	local commit_msg="Update $file"
	(cd "$NOTES_DIR" &&
		git add "$file" &&
		git commit --quiet --message="$commit_msg" 1>/dev/null || true)

	# Automatically sync the notes, if that is required.
	if [[ "$NOTES_AUTO_SYNC" == "true" || "$NOTES_AUTO_SYNC" == "1" ]]; then
		(cd "$NOTES_DIR" && git push --quiet)
	fi
}

search() {
	# TODO: support multiple key words.
	local key_word="$1"

	if [[ "$EDITOR" == "vim" ]]; then
		# Open all files at once using tabs.
		vim -p `search_files "$key_word"`
	else
		# Open all files one after another.
		for file in `search_files "$key_word"`; do
			$EDITOR "$file"
		done
	fi
}

search_files() {
	local key_word="$1"
	# TODO: port to plain grep.
	rg --ignore-case --files-with-matches "$key_word" "$NOTES_DIR"
}

setup

case ${1:-"OPEN_DAILY"} in
	help|--help)
		help
	;;
	daily|OPEN_DAILY)
		open_daily
	;;
	subject)
		open_subject "$2"
	;;
	search)
		search "$2"
	;;
	*)
		open_subject "$1"
	;;
esac
