# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Dotfiles managed as infrastructure using Ansible + GNU Stow + Git. See `AGENT.md` for full best-practices reference and `.github/copilot-instructions.md` for architecture details.

## Key Commands

```bash
# Run all tests (unit + feature + integration) in Docker
./tests/run-all.sh
./tests/run-all.sh --verbose

# Interactive dev shell (runs setup in Docker, drops into bash)
./dev/shell.sh

# Deploy to host
ansible-playbook src/setup.yml --ask-become-pass

# Dry-run / syntax check
ansible-playbook src/setup.yml --check --diff
ansible-playbook --syntax-check src/setup.yml

# Apply a single tag
ansible-playbook src/setup.yml --tags <tag>

# Stow (run from src/resources/)
stow <package>       # create symlinks
stow -D <package>    # remove symlinks
stow --adopt <pkg>   # adopt existing files into the package
```

## Ansible Conventions

- Use `ansible_facts['env']['HOME']` and `ansible_facts['date_time']['epoch']` — do **not** use `ansible_env` or bare `HOME` vars (deprecated injection)
- Target OS: Arch Linux only (Archlinux, Manjaro, EndeavourOS) — no other distros supported
- All tasks must be idempotent; test with `--check --diff` before running
- Use `become: true` only on tasks that require elevated privileges

## Stow / Package Structure

- Stow packages live in `src/resources/<package>/`
- File paths inside the package mirror the home directory structure (e.g., `src/resources/zsh/.zshrc` → `~/.zshrc`)
- Existing dotfiles are backed up to `~/.dotfiles-backups/<epoch>/` before being overwritten — mention this when suggesting destructive changes

## Testing

- All tests run in Docker containers; never modify the host system directly
- Test helpers are in `tests/lib/test-helpers.sh`
- Test categories: `tests/unit/` (syntax/lint), `tests/feature/` (per-role), `tests/integration/` (end-to-end)
- Output style: PestPHP-style (green pass / red fail), fully automated — no interactive prompts

## Git Workflow

- Commit style: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, etc.)
- Push directly to `main` — no PR workflow
