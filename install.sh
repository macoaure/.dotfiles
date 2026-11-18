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
  read -rsp "[sudo] password for $(whoami): " _sudo_pass
  echo
  echo "$_sudo_pass" | sudo -S pacman -S --needed --noconfirm base-devel make ansible
  ANSIBLE_BECOME_PASSWORD="$_sudo_pass" ansible-playbook "$DOTFILES_DIR/playbook.yml"
  unset _sudo_pass
fi
