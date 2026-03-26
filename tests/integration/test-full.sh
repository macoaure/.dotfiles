#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Integration: Full Setup"

# Set up the dotfiles symlink for the test
ln -sf /repo ~/.dotfiles

# Install curl if needed
pacman -Syu --noconfirm --quiet && pacman -S --noconfirm --quiet curl 2>/dev/null || true

# Verify playbook syntax (full role tree)
output=$(ansible-playbook --syntax-check src/setup.yml 2>&1)
assert_success "Ansible playbook syntax check"
assert_output_contains "Syntax check output" "playbook: src/setup.yml" "$output"

# Verify all expected roles are present
for role in base aur-helper vscode cursor claude-code codex rtk zsh docker mise stow; do
  assert_file_exists "Role $role exists" "src/roles/$role/tasks/main.yml"
done

# Verify stow packages are present
assert_file_exists "zsh stow package"  "src/resources/zsh/.zshrc"
assert_file_exists "git stow package"  "src/resources/git/.gitconfig"
assert_file_exists "nano stow package" "src/resources/nano/.nanorc"

echo "Full integration test passed!"
