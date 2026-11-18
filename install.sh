#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $EUID -eq 0 ]]; then
  pacman -S --needed --noconfirm base-devel make ansible
  ansible-playbook "$DOTFILES_DIR/playbook.yml"
else
  sudo -v
  sudo pacman -S --needed --noconfirm base-devel make ansible
  if sudo -n true 2>/dev/null; then
    ansible-playbook "$DOTFILES_DIR/playbook.yml"
  else
    ansible-playbook "$DOTFILES_DIR/playbook.yml" --ask-become-pass
  fi
fi
