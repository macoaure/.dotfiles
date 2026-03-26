#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Dev Tools Roles"

assert_file_exists "aur-helper role exists"  "src/roles/aur-helper/tasks/main.yml"
assert_file_exists "vscode role exists"       "src/roles/vscode/tasks/main.yml"
assert_file_exists "cursor role exists"       "src/roles/cursor/tasks/main.yml"
assert_file_exists "claude-code role exists"  "src/roles/claude-code/tasks/main.yml"
assert_file_exists "codex role exists"        "src/roles/codex/tasks/main.yml"
assert_file_exists "rtk role exists"          "src/roles/rtk/tasks/main.yml"

# Verify role task files are valid YAML
for role in aur-helper vscode cursor claude-code codex rtk; do
  output=$(python3 -c "import yaml, sys; yaml.safe_load(open('src/roles/$role/tasks/main.yml'))" 2>&1)
  assert_success "src/roles/$role/tasks/main.yml is valid YAML"
done

# Verify setup.yml includes all new roles
for role in aur-helper vscode cursor claude-code codex rtk; do
  output=$(grep -c "$role" src/setup.yml)
  assert_output_contains "setup.yml includes $role" "$role" "$(cat src/setup.yml)"
done

echo "Dev Tools feature tests passed!"
