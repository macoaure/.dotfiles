#!/usr/bin/env bash
set -euo pipefail

_script="${BASH_SOURCE[0]:-}"
if [[ -z "$_script" ]]; then
  echo "install.sh must be run from a cloned repo, not piped from curl." >&2
  echo "For a fresh install use:" >&2
  echo "  sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/macoaure/.dotfiles/main/bootstrap.sh)\"" >&2
  exit 1
fi
DOTFILES_DIR="$(cd "$(dirname "$_script")" && pwd)"

if [[ $EUID -eq 0 ]]; then
  pacman -S --needed --noconfirm base-devel make ansible
  ansible-playbook "$DOTFILES_DIR/playbook.yml"
else
  sudo pacman -S --needed --noconfirm base-devel make ansible
  ansible-playbook "$DOTFILES_DIR/playbook.yml" --ask-become-pass
fi
