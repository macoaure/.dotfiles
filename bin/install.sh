#!/bin/bash

set -e

REPO_URL="https://github.com/macoaure/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Verify Arch Linux
if ! command -v pacman &> /dev/null; then
    echo "Error: this installer requires Arch Linux (pacman not found)."
    exit 1
fi

# Install git if needed
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    sudo pacman -S --noconfirm git
fi

# Install Ansible if needed
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    sudo pacman -S --noconfirm ansible
fi

# Clone repo if not present
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "Dotfiles directory already exists, skipping clone."
fi

cd "$DOTFILES_DIR"

echo "Running Ansible playbook..."
ansible-playbook src/setup.yml --ask-become-pass

echo "Dotfiles installation complete!"
