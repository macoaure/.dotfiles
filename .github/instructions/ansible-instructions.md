# Ansible Coding Standards and Testing Ruleset

## Overview
This ruleset defines coding standards for Ansible playbooks, roles, and tasks in this .dotfiles project. Follow a red-green testing cycle: write code, test (red if fails), iterate fixes, until all checks pass (green).

## Coding Standards
- **Idempotency**: Ensure playbooks run multiple times without side effects.
- **Modularity**: Use roles for reusable components; avoid monolithic playbooks.
- **Variables**: Use descriptive variable names; define in `vars/` or `group_vars/`.
- **Templates**: Use Jinja2 templates for dynamic configs (e.g., `roles/zsh/templates/.zshrc.j2`).
- **Tags**: Tag tasks for selective execution (e.g., `--tags zsh`).
- **Cross-Platform**: Use `when` conditionals for OS-specific logic (e.g., `when: ansible_os_family == 'Debian'`).
- **Secrets**: Use Ansible Vault for sensitive data; never hardcode.
- **Documentation**: Comment complex tasks; use YAML formatting consistently.

## Folder and Coding Structure
- **Root Level**: Place main playbooks (e.g., `playbook.yml`, `setup.yml`) at root.
- **Roles Directory**: Organize roles under `roles/` (e.g., `roles/zsh/`, `roles/vim/`).
- **Role Structure**: Each role should have `tasks/main.yml`, `handlers/main.yml`, `templates/`, `vars/main.yml`, `defaults/main.yml`.
- **Variables**: Use `vars/` for role-specific vars, `group_vars/` for host/group vars.
- **Templates**: Store Jinja2 templates in `roles/<role>/templates/` (e.g., `.zshrc.j2`).
- **Playbook Organization**: Use includes for modular playbooks; avoid long single files.
- **File Naming**: Use lowercase with hyphens (e.g., `install-packages.yml`); consistent YAML extension.

## Testing Cycle: Red → Build → Iterate → Green

### 1. Red Status: Initial Test
- Run syntax check: `ansible-playbook --syntax-check playbook.yml`
- Lint code: `ansible-lint roles/ playbook.yml`
- Dry run: `ansible-playbook --check playbook.yml`
- Simulate in Docker: Run tests in isolated Docker containers to avoid affecting host system (e.g., `docker run -v $(pwd):/ansible ubuntu:20.04 ansible-playbook --syntax-check /ansible/playbook.yml`).
- If any fail (red), proceed to iterate.

### 2. Build
- Execute playbook: `ansible-playbook playbook.yml`
- Monitor for runtime errors or unexpected changes.
- Prefer Docker simulation for builds to ensure portability.

### 3. Iterate
- Fix syntax errors, lint warnings, or logic issues.
- Re-run tests in Docker; repeat until all pass.
- Use `ansible-playbook --diff` to preview changes.
- Test on multiple environments if possible, using different Docker images (e.g., Debian, CentOS).

### 4. Green Status
- All checks pass: syntax OK, lint clean, dry run succeeds, playbook executes without errors in Docker.
- Commit changes with descriptive message.

## Key Commands
- Syntax: `ansible-playbook --syntax-check <file>`
- Lint: `ansible-lint <path>`
- Dry Run: `ansible-playbook --check <file>`
- Full Run: `ansible-playbook <file>`
- Diff: `ansible-playbook --diff <file>`

## Integration
- Run tests before deploying to production.
- Use CI/CD for automated checks if available.
- Reference [AGENT.md](AGENT.md) for Ansible best practices.