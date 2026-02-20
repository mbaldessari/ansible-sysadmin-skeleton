# Ansible Sysadmin Skeleton

A small skeleton of files and folders for ansible-driven sysadmin tasks.

## Prerequisites

- Ansible >= 2.16
- Python 3
- `ansible-lint` and `yamllint` (for linting)

## Directory Layout

```
.
├── ansible.cfg          # Ansible configuration
├── hosts                # Inventory file
├── requirements.yml     # Galaxy collections and roles
├── Makefile             # Common task targets
├── group_vars/          # Variables applied to host groups
│   └── all             # Variables for all hosts
├── host_vars/           # Per-host variables
├── vault_vars/          # Encrypted variable files (ansible-vault)
├── playbooks/           # Playbooks
│   └── foo.yml
├── roles/               # Roles
│   └── hello/
├── templates/           # Jinja2 templates (shared across playbooks)
├── files/               # Static files for deployment
└── filter_plugins/      # Custom Jinja2 filter plugins
```

## Getting Started

Install dependencies:

```bash
make deps
```

## Running Playbooks

```bash
# Run a playbook
make foo

# Dry-run with diff output
make foo-check

# Target specific hosts
make foo LIMIT=foo.int.lab

# Run specific tags
make foo TAGS=config

# Increase verbosity (1-4)
make foo VERBOSE=2

# Combine options
make foo TAGS=config LIMIT=foo.int.lab VERBOSE=1
```

## Using Vault for Secrets

See [vault_vars/README.md](vault_vars/README.md) for details on managing
encrypted variables with `ansible-vault`.

## Adding a New Playbook

1. Create `playbooks/yourplay.yml`
2. Add a corresponding Makefile target:

```makefile
.PHONY: yourplay
yourplay: ## Description of yourplay
	ansible-playbook $(ANSIBLE_ARGS) playbooks/yourplay.yml
```

## Adding a New Role

```bash
ansible-galaxy role init roles/yourrolename
```

Then include it in a playbook:

```yaml
- name: Your role
  ansible.builtin.include_role:
    name: yourrolename
```

## Linting

```bash
make lint        # ansible-lint
make yamllint    # yamllint
make syntax-check  # syntax-check all playbooks
```

## Fact Caching

Fact caching is enabled using JSON files stored in `.ansible/facts/` with a
600-second timeout. This directory is gitignored and will not persist across
fresh clones.

Run `make help` to see all available targets.
