#!/bin/bash

# Dotfiles Development Shell Script
# Runs the Ansible playbook in an Arch Linux Docker container and drops into a shell
# for interactive testing and inspection of the dotfiles setup

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status()  { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
print_status "Dotfiles directory: $DOTFILES_DIR"
print_status "Starting Arch Linux Docker container..."
print_status "This may take a few minutes on first run."

docker run -it --rm -v "$DOTFILES_DIR:/repo" archlinux:latest bash -c "
    set -e

    # Bootstrap Ansible on Arch
    pacman -Syu --noconfirm --quiet
    pacman -S --noconfirm --quiet ansible git stow curl

    cd /repo

    echo 'Running Ansible playbook...'
    ansible-playbook src/setup.yml

    echo ''
    echo 'Setup completed! Dropping into bash for inspection.'
    echo 'Type \"exit\" to leave the container.'
    echo ''

    exec bash
"
