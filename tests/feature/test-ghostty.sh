#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Ghostty Installation"

# Test Ghostty installation on Arch Linux (current system)
if command -v pacman &> /dev/null; then
    echo "Testing on Arch-based system..."

    # Check if Ghostty is available in repositories
    output=$(pacman -Ss ghostty)
    assert_success "Ghostty package search"
    assert_output_contains "Ghostty found in repos" "ghostty" "$output"

    # Check if Ghostty can be installed (dry run)
    output=$(pacman -S --noconfirm --dry-run ghostty)
    assert_success "Ghostty installation dry run"
    assert_output_contains "would be installed" "ghostty" "$output"

elif command -v apt &> /dev/null; then
    echo "Testing on Debian-based system..."

    # For Ubuntu/Debian, test the download URLs
    ubuntu_version=$(lsb_release -rs 2>/dev/null || echo "20.04")
    ubuntu_version_clean=$(echo "$ubuntu_version" | tr -d '.')

    # Test version-specific download
    if curl -fsSL --head "https://github.com/mkasberg/ghostty-ubuntu/releases/latest/download/ghostty_amd64_${ubuntu_version_clean}.deb" >/dev/null 2>&1; then
        echo "Version-specific package available for Ubuntu $ubuntu_version"
    else
        # Test generic download
        output=$(curl -fsSL --head "https://github.com/mkasberg/ghostty-ubuntu/releases/latest/download/ghostty_amd64.deb" 2>&1)
        assert_success "Generic Ghostty package download check"
    fi
fi

# Test that Ghostty configuration exists
assert_file_exists "Ghostty config directory exists" "src/resources/ghostty/.config/ghostty/config"

# Test that the config contains expected settings
config_content=$(cat src/resources/ghostty/.config/ghostty/config)
assert_output_contains "Config sets Zsh shell" "shell = zsh" "$config_content"
assert_output_contains "Config has font settings" "font-family" "$config_content"
assert_output_contains "Config has theme setting" "theme =" "$config_content"

echo "All Ghostty feature tests passed!"