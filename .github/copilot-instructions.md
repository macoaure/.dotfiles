# Copilot Instructions for .dotfiles Management

## Instructions

Before performing any task, search for relevant instructions in the `.github/instructions` directory.

## Project Overview
This repository manages dotfiles using Ansible for automation, Git for version control, and Stow for symlink management. The goal is portable, maintainable configuration across machines.

## Architecture
- **Packages**: Organize dotfiles into directories (e.g., `zsh/`, `vim/`) mirroring home directory structure or logical groups.
- **Ansible Roles**: Create roles under `roles/` for each package (e.g., `roles/zsh/`) to handle installation and configuration.
- **Playbook**: Use `playbook.yml` to orchestrate setup, including role application and system tasks.
- **Data Flow**: Git repo → Stow creates symlinks in `~/` → Ansible configures tools and dependencies.

Structural decisions prioritize minimalism and cross-platform compatibility.

## Developer Workflows
- **Setup**: `git clone <repo>; cd .dotfiles; ansible-playbook setup.yml`
- **Add Package**: Create directory, add files, run `stow <package>` to test symlinks.
- **Deploy**: `ansible-playbook playbook.yml --tags <package>` for targeted updates.
- **Adopt Existing**: `stow --adopt <package>` to integrate current dotfiles.
- **Debug**: Use `ansible-playbook --check` for dry runs; check Stow conflicts with `stow --conflicts <package>`.

## Conventions and Patterns
- **Package Naming**: Use tool names (e.g., `git/`, `tmux/`) or categories (e.g., `shell/`, `editor/`).
- **File Placement**: Place configs directly in package dirs, e.g., `zsh/.zshrc`, `vim/.vimrc`.
- **Ansible Templates**: Use Jinja2 for dynamic configs, e.g., `roles/zsh/templates/.zshrc.j2`.
- **Variables**: Define user-specific vars in `vars/` or `group_vars/`.
- **Tags**: Tag roles for selective runs, e.g., `--tags zsh,vim`.
- **Idempotency**: Ensure playbooks run multiple times safely.

## Integration Points
- **External Dependencies**: Ansible handles package installation (e.g., `apt`, `brew`) via roles.
- **Secrets**: Use Ansible Vault for sensitive data; never commit plain text.
- **Cross-Platform**: Use `when` conditionals for OS-specific tasks, e.g., `when: ansible_facts.get("os_family") == 'Debian'`. (avoid `INJECT_FACTS_AS_VARS`-style globals) 
- **Communication**: Roles communicate via shared facts or variables; avoid tight coupling.

## Key Files
- [AGENT.md](AGENT.md): Detailed best practices for Git, Stow, Ansible integration.
- [README.md](README.md): Quick start and usage overview.

Focus on discoverable patterns from [AGENT.md](AGENT.md) and [README.md](README.md); avoid over-engineering.