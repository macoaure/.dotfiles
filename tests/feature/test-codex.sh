#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Codex CLI"

assert_file_exists "Codex role exists" "src/roles/codex/tasks/main.yml"

output=$(python3 -c "import yaml, sys; yaml.safe_load(open('src/roles/codex/tasks/main.yml'))" 2>&1)
assert_success "Codex role is valid YAML"

assert_output_contains "Codex role references openai-codex package" "openai-codex" "$(cat src/roles/codex/tasks/main.yml)"

# Install and verify in Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "SKIP: Docker not available"
  exit 0
fi

echo "  Installing openai-codex in Arch container..."
output=$(docker run --rm archlinux:latest bash -c "
  set -e
  pacman -Syu --noconfirm --quiet 2>/dev/null
  pacman -S --noconfirm --quiet openai-codex 2>/dev/null
  codex --version
" 2>&1) || rc=$?

rc=${rc:-0}
if [ "$rc" -ne 0 ]; then
  echo "FAIL: Codex installation failed (rc=$rc)"
  echo "$output"
  exit 1
fi

assert_success "Codex installed successfully"
assert_output_contains "codex binary runs" "codex" "$output"
echo "  Version: $(echo "$output" | tail -1)"

echo "All Codex feature tests passed!"
