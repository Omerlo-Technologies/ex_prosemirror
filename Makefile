MIX_ENV ?= prod

define HELP
Usage:
	make lint
		Lint all files in the app.
		This is the same as calling:
		make lint-elixir && make lint-scripts

	make lint-elixir
		Lint all elixir files in the app.

	make lint-scripts
		Lint all JavaScript files in the app.

	make lint-fix
		Quickly fix linting errors that do not require manual input

	make help
		Shows this help message

	make docs
		Generate docs for ex_prosemirror # Should be remove when release to public
endef


.PHONY: lint
lint: lint-elixir lint-scripts ## Lint project files

.PHONY: lint-elixir
lint-elixir:
	mix credo --strict
	mix format --check-formatted

.PHONY: lint-scripts
lint-scripts:
	cd assets && npx eslint .


.PHONY: lint-fix
lint-fix:
	mix format
	cd assets && npx eslint . --fix

.PHONY: docs
docs:
	rm -rf docs
	mix docs -o docs
	git add docs
.PHONY: help
help:
	$(info $(HELP))
