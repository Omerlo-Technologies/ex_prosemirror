MIX_ENV ?= prod

STYLES_PATTERN = 'css'

define HELP
Usage:
	make lint
		Lint all files in the app.
		This is the same as calling:
		make lint-elixir && make lint-scripts && make lint-styles

	make lint-elixir
		Lint all elixir files in the app.

	make lint-scripts
		Lint all JavaScript files in the app.

	make lint-styles
		Lint all SCSS/CSS files in the app.

	make lint-fix
		Quickly fix linting errors that do not require manual input

	make help
		Shows this help message

	make docs
		Generate docs for ex_prosemirror # Should be remove when release to public
endef


.PHONY: lint
lint: lint-elixir lint-scripts lint-styles ## Lint project files

.PHONY: lint-elixir
lint-elixir:
	mix compile --warnings-as-errors --force
# mix credo --strict
	mix format --check-formatted

.PHONY: lint-scripts
lint-scripts:
#	cd assets && npx eslint .

.PHONY: lint-styles
lint-styles:
#	cd aassets && npx stylelint --syntax scss $(STYLES_PATTERN)

.PHONY: lint-fix
lint-fix:
	mix format
#	cd assets && npx eslint . --fix
#	cd assets && npx stylelint --syntax scss $(STYLES_PATTERN) --fix

.PHONY: docs
docs:
	mix docs -o docs
.PHONY: help
help:
	$(info $(HELP))
