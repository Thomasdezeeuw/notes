define HELP
Commands:
	test		Run all tests.
	install		Links `note.bash` to ~/bin/note.
endef
export HELP

help:
	@$(info $(HELP))

test:
	@for test in tests/*.bash; do ./$$test || exit 1; done
	@echo "Ok."

install:
	ln -v -s "`pwd`/note.bash" "$$HOME/bin/note"

.PHONY: help test install
