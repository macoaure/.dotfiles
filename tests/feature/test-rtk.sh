#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: RTK"

assert_file_exists "RTK role exists" "src/roles/rtk/tasks/main.yml"

output=$(python3 -c "import yaml, sys; yaml.safe_load(open('src/roles/rtk/tasks/main.yml'))" 2>&1)
assert_success "RTK role is valid YAML"

assert_output_contains     "RTK role uses official installer"     "rtk-ai/rtk"              "$(cat src/roles/rtk/tasks/main.yml)"
assert_output_contains     "RTK role uses shell installer"        "install.sh"              "$(cat src/roles/rtk/tasks/main.yml)"
assert_output_not_contains "RTK role does not use wrong crate"    "cargo install rtk"       "$(grep -v '#' src/roles/rtk/tasks/main.yml)"
assert_output_contains     "RTK role initialises hooks"           "rtk init -g"             "$(cat src/roles/rtk/tasks/main.yml)"

# Install and verify in Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "SKIP: Docker not available"
  exit 0
fi

echo "  Installing RTK in Arch container..."
output=$(docker run --rm archlinux:latest bash -c "
  set -e
  pacman -Syu --noconfirm --quiet 2>/dev/null
  pacman -S --noconfirm --quiet curl 2>/dev/null
  curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
  ~/.local/bin/rtk --version
" 2>&1) || rc=$?

rc=${rc:-0}
if [ "$rc" -ne 0 ]; then
  echo "FAIL: RTK installation failed (rc=$rc)"
  echo "$output"
  exit 1
fi

assert_success "RTK installed successfully"
assert_output_contains "rtk binary runs" "rtk" "$output"
echo "  Version: $(echo "$output" | grep -i rtk | tail -1)"

echo "All RTK feature tests passed!"
