# hello

Prints a debug greeting message.

## Role Variables

None.

## Dependencies

None.

## Example Playbook

```yaml
- hosts: servers
  tasks:
    - name: Run hello role
      ansible.builtin.include_role:
        name: hello
```

## License

MIT
