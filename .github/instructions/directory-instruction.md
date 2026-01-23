# Project Folder Structure Rules

## Overview
This document defines the clean folder structure for the .dotfiles project, separating concerns for development, source code, installation, testing, and documentation.

## Root Level Structure
- `dev/`: Development environment scripts and proposals.
- `src/`: Core codebase, including Stow packages and Ansible roles.
- `bin/`: Singleton installer script for one-command repository setup.
- `tests/`: Test suites and validation scripts for the repository.
- `docs/`: Documentation files.
- `README.md`: Project overview.
- `AGENT.md`: Best practices guide.

## dev/ Structure
- Scripts for setting up dev environments (e.g., `setup-dev.sh`).
- Proposed changes or experimental scripts.

## src/ Structure
- `packages/`: Stow packages for dotfiles (e.g., `packages/zsh/`, `packages/vim/`).
- `roles/`: Ansible roles (e.g., `roles/zsh/`, `roles/vim/`).
- `vars/`: Global Ansible variables.
- `group_vars/`: Group-specific variables.
- `inventory/`: Ansible inventory files.
- `playbook.yml`: Main Ansible playbook.
- `setup.yml`: Initial setup playbook.

## bin/ Structure
- Single executable script (e.g., `install.sh`) for full repository installation.

## tests/ Structure
- Test scripts for Ansible (e.g., `test-ansible.sh`).
- Docker-based test environments.
- Validation for Stow symlinks and playbook execution.

## docs/ Structure
- Additional documentation beyond root files.
- Guides, examples, and troubleshooting.

## Rules
- Keep directories flat and minimal within each top-level folder.
- Use lowercase names with hyphens for subdirectories.
- Ensure `bin/install.sh` handles cloning, Stow setup, and Ansible deployment in one command.
- Run tests from `tests/` before commits.