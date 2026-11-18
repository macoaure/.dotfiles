#!/bin/sh
set -eu

DOTFILES_DIR="${HOME}/.dotfiles"
REPO="https://github.com/macoaure/.dotfiles.git"

if ! command -v git > /dev/null 2>&1; then
  if [ "$(id -u)" -eq 0 ]; then
    pacman -Sy --needed --noconfirm git
  else
    sudo pacman -Sy --needed --noconfirm git
  fi
fi

git clone "$REPO" "$DOTFILES_DIR"
bash "$DOTFILES_DIR/install.sh"
