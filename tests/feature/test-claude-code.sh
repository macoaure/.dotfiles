#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Claude Code"

assert_file_exists "Claude Code role exists" "src/roles/claude-code/tasks/main.yml"

output=$(python3 -c "import yaml, sys; yaml.safe_load(open('src/roles/claude-code/tasks/main.yml'))" 2>&1)
assert_success "Claude Code role is valid YAML"

assert_output_contains "Claude Code role uses native installer" "claude.ai/install.sh" "$(cat src/roles/claude-code/tasks/main.yml)"
assert_output_contains "Claude Code role adds to PATH"         ".local/bin"            "$(cat src/roles/claude-code/tasks/main.yml)"

# Install and verify in Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "SKIP: Docker not available"
  exit 0
fi

echo "  Installing Claude Code in Arch container..."
output=$(docker run --rm archlinux:latest bash -c "
  set -e
  pacman -Syu --noconfirm --quiet 2>/dev/null
  pacman -S --noconfirm --quiet curl 2>/dev/null
  curl -fsSL https://claude.ai/install.sh | bash
  ~/.local/bin/claude --version
" 2>&1) || rc=$?

rc=${rc:-0}
if [ "$rc" -ne 0 ]; then
  echo "FAIL: Claude Code installation failed (rc=$rc)"
  echo "$output"
  exit 1
fi

assert_success "Claude Code installed successfully"
assert_output_contains "claude binary runs" "claude" "$output"
echo "  Version: $(echo "$output" | grep -i claude | tail -1)"

echo "All Claude Code feature tests passed!"
