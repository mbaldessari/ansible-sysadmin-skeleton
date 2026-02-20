TAGS ?=
LIMIT ?=
VERBOSE ?=

ifdef TAGS
	TAGS_STRING = --tags $(TAGS)
endif
ifdef LIMIT
	LIMIT_STRING = --limit $(LIMIT)
endif
ifdef VERBOSE
	VERBOSE_STRING = -$(shell printf 'v%.0s' $$(seq 1 $(VERBOSE)))
endif

ANSIBLE_ARGS = -i hosts $(TAGS_STRING) $(LIMIT_STRING) $(VERBOSE_STRING)

##@ Setup
.PHONY: help
help: ## This help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^(\s|[a-zA-Z_0-9-])+:.*?##/ { printf "  \033[36m%-35s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: deps
deps: ## Install ansible-galaxy collections and roles from requirements.yml
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy role install -r requirements.yml

##@ Common Tasks
.PHONY: foo
foo: ## Install foo (TAGS=sometag LIMIT=host VERBOSE=2)
	ansible-playbook $(ANSIBLE_ARGS) playbooks/foo.yml

.PHONY: foo-check
foo-check: ## Dry-run foo with --check --diff
	ansible-playbook $(ANSIBLE_ARGS) --check --diff playbooks/foo.yml

##@ CI / Linter tasks
.PHONY: lint
lint: ## Run ansible-lint on the codebase
	ansible-lint -v

.PHONY: yamllint
yamllint: ## Run yamllint on the codebase
	yamllint .

.PHONY: syntax-check
syntax-check: ## Run ansible-playbook --syntax-check on all playbooks
	@for pb in playbooks/*.yml; do \
		echo "Checking $$pb..."; \
		ansible-playbook --syntax-check $$pb; \
	done
