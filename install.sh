#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $EUID -eq 0 ]]; then
  pacman -S --needed --noconfirm base-devel make ansible
else
  sudo pacman -S --needed --noconfirm base-devel make ansible
fi

ansible-playbook "$DOTFILES_DIR/playbook.yml"
