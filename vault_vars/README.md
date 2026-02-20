# Vault Variables

Store encrypted variable files here using `ansible-vault`.

## Usage

Create an encrypted file:

```bash
ansible-vault create vault_vars/secrets.yml
```

Edit an existing encrypted file:

```bash
ansible-vault edit vault_vars/secrets.yml
```

Reference vault variables in playbooks by including the file:

```yaml
- hosts: all
  vars_files:
    - "{{ base_dir }}/vault_vars/secrets.yml"
  tasks:
    - name: Use a secret
      ansible.builtin.debug:
        msg: "{{ vault_db_password }}"
```

Run playbooks with vault:

```bash
ansible-playbook -i hosts --ask-vault-pass playbooks/foo.yml
# or using a password file
ansible-playbook -i hosts --vault-password-file ~/.vault_pass playbooks/foo.yml
```
