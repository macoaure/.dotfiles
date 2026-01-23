#!/bin/bash

set -e

REPO_URL="https://github.com/macoaure/.dotfiles.git"

DOTFILES_DIR="$HOME/.dotfiles"

# Install Ansible if not present

if ! command -v ansible-playbook &> /dev/null; then

  echo "Installing Ansible..."

  if command -v apt &> /dev/null; then

    sudo apt update

    sudo apt install -y ansible

  elif command -v yum &> /dev/null; then

    sudo yum install -y ansible

  elif command -v dnf &> /dev/null; then

    sudo dnf install -y ansible

  elif command -v brew &> /dev/null; then

    brew install ansible

  else

    echo "Please install Ansible manually. Supported package managers: apt, yum, dnf, brew"

    exit 1

  fi

fi

# Clone repo if not exists

if [ ! -d "$DOTFILES_DIR" ]; then

  echo "Cloning dotfiles repository..."

  git clone "$REPO_URL" "$DOTFILES_DIR"

fi

cd "$DOTFILES_DIR"

echo "Running Ansible playbook..."

ansible-playbook src/setup.yml

echo "Dotfiles installation complete!"