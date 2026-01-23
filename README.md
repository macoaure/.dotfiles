# macoaure/.dotfiles

> [!WARNING]
> This is a personal repository, do not use it as-is without understanding its contents and implications.

This repository is a small, practical system for treating a personal environment as _infrastructure_. It captures the idea that your shell, editor, and common tool configurations should be:

- **Declarative** — stored as files in version control (Git)
- **Reproducible** — deployable to any machine with minimal steps (Ansible)
- **Non-invasive** — symlinked into your home directory without clutter (Stow)

---

## Core Principles ✨

- **Source of Truth**: The repository is the canonical record of your configuration; make small, reviewable changes.
- **Idempotency**: Running the setup repeatedly yields the same result without manual cleanup.
- **Safety**: Existing user files are preserved and backed up before being replaced.
- **Composability**: Add or remove packages independently; each package should be self-contained.

---

## Architecture — How it fits together 🔧

- Git: stores configuration and change history.
- Stow: manages symlinks from package folders in `src/resources/` into your `$HOME`.
- Ansible: orchestrates system packages, tool installs (e.g., Zsh, Ghostty), and runs the user-level setup steps.
- Helper scripts: a small `bin/install.sh` and `dev/shell.sh` support one-line installs and local testing.

> Note: `src/setup.yml` includes safe-guards to back up pre-existing files and plugins before overwriting them.

---

## Workflow — day-to-day usage 🚦

1. Make or edit files under `src/resources/<package>/` (e.g., `zsh/`, `git/`, `nano/`).
2. Test locally with `./dev/shell.sh` which runs a disposable container and executes the playbook.
3. Apply to a real machine with:

```bash
ansible-playbook src/setup.yml
```

4. Use Stow to manage symlinks (Ansible handles this automatically in the playbook):

```bash
cd src/resources
stow <package>
```

---

## Adding a new package 🧩

- Create a new folder in `src/resources/<package>/` and add files with their intended target paths (dotfiles at the top level of the package).
- Optionally add an Ansible task/role if system-wide packages or services are required.
- Test via `dev/shell.sh` and then run `ansible-playbook src/setup.yml`.

---

## Safety & Backups 🔐

This project favors safety: when a file in the home directory would be overwritten, the playbook moves the existing file to a timestamped backup location (e.g., `~/.dotfiles-backups/<epoch>/`). Review backups before removing them.