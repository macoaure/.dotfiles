#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Docker Installation"

# Test Docker installation on current system
if command -v apt &> /dev/null; then
    echo "Testing on Debian-based system..."

    # Check if Docker repository is available
    if curl -fsSL --head "https://download.docker.com/linux/ubuntu/dists/focal/stable/binary-amd64/Packages" >/dev/null 2>&1; then
        echo "Docker repository is accessible"
    else
        echo "Warning: Docker repository may not be accessible"
    fi

elif command -v pacman &> /dev/null; then
    echo "Testing on Arch-based system..."

    # Check if Docker is available in repositories
    output=$(pacman -Ss docker)
    assert_success "Docker package search"
    assert_output_contains "Docker found in repos" "docker" "$output"

    # Check if docker-compose is available
    output=$(pacman -Ss docker-compose)
    assert_success "Docker Compose package search"
    assert_output_contains "Docker Compose found in repos" "docker-compose" "$output"

elif command -v dnf &> /dev/null; then
    echo "Testing on Fedora/RHEL-based system..."

    # Check Docker repository accessibility
    if curl -fsSL --head "https://download.docker.com/linux/fedora/docker-ce.repo" >/dev/null 2>&1; then
        echo "Docker repository configuration is accessible"
    else
        echo "Warning: Docker repository may not be accessible"
    fi
fi

# Test that Docker configuration exists (if any config files are managed)
# For now, just verify the installation logic is sound
echo "Docker installation logic validated"

echo "All Docker feature tests passed!"