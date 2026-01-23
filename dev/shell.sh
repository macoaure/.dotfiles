#!/bin/bash

# Dotfiles Development Shell Script
# This script runs the Ansible playbook in a Docker container and then drops you into a bash shell
# for interactive testing and inspection of the dotfiles setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Get the absolute path of the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
print_status "Dotfiles directory: $DOTFILES_DIR"

# Run the Docker container with the Ansible playbook
print_status "Starting Docker container to test dotfiles setup..."
print_status "This may take a few minutes..."
print_status "After setup completes, you'll be dropped into a bash shell for inspection."

docker run -it --rm -v "$DOTFILES_DIR:/repo" ubuntu:20.04 bash -c "
    set -e

    # Update package list quietly
    apt update -qq

    # Install required packages
    apt install -y -qq ansible git stow python3-apt curl

    # Change to the repo directory
    cd /repo

    # Run the Ansible playbook
    echo 'Running Ansible playbook...'
    ansible-playbook src/setup.yml

    echo 'Setup completed successfully!'
    echo ''
    echo 'Dropping into bash shell for inspection...'
    echo 'You can now test the dotfiles setup interactively.'
    echo 'Type \"exit\" to leave the container.'
    echo ''

    # Drop into interactive bash shell
    exec bash
"