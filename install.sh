#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo pacman -S --needed --noconfirm base-devel make ansible

ansible-playbook "$DOTFILES_DIR/playbook.yml"
