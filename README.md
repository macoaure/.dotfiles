<div align="center">
  <img src="assets/logo.svg" alt=".dotfiles" width="96" /><br/><br/>
  <strong>macoaure/.dotfiles</strong><br/>
  <sub>Personal environment as infrastructure — declarative, reproducible, Arch Linux.</sub>

  <br/><br/>

  [![Test](https://github.com/macoaure/.dotfiles/actions/workflows/test.yml/badge.svg)](https://github.com/macoaure/.dotfiles/actions/workflows/test.yml)
  ![Platform](https://img.shields.io/badge/platform-Arch%20Linux-1793D1?logo=arch-linux&logoColor=white)
  ![Ansible](https://img.shields.io/badge/provisioned%20by-Ansible-EE0000?logo=ansible&logoColor=white)
  ![Stow](https://img.shields.io/badge/symlinks-GNU%20Stow-4B8BBB?logo=gnu&logoColor=white)
</div>

---

## Quickstart

```bash
curl -sSL https://raw.githubusercontent.com/macoaure/.dotfiles/main/bin/install.sh | bash
```

Or manually:

```bash
sudo pacman -S git ansible
git clone https://github.com/macoaure/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ansible-playbook src/setup.yml --ask-become-pass
```

> Existing dotfiles are backed up to `~/.dotfiles-backups/<epoch>/` before any overwrite.

---

## Structure

| Path | Purpose |
|---|---|
| `src/roles/` | Ansible roles — one per tool (`base`, `zsh`, `docker`, `mise`, `vscode`, …) |
| `src/resources/` | Stow packages — configs symlinked into `$HOME` |
| `tests/` | Feature + integration tests (run in Docker) |
| `dev/shell.sh` | Interactive Arch Linux container for local testing |

---

## Commands

```bash
# Deploy
ansible-playbook src/setup.yml --ask-become-pass

# Dry-run
ansible-playbook src/setup.yml --check --diff

# Single role
ansible-playbook src/setup.yml --tags <role>

# Run tests
./tests/run-all.sh [--verbose]

# Interactive dev shell
./dev/shell.sh
```

---

## Adding a package

1. Create `src/resources/<package>/` mirroring `$HOME` paths.
2. Add a role in `src/roles/<package>/tasks/main.yml` if system packages are needed.
3. Test with `./dev/shell.sh`, then deploy.

---

> [!WARNING]
> Personal repository — review before use. Arch Linux only.
