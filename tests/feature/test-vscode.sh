#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: VSCode"

assert_file_exists "VSCode role exists" "src/roles/vscode/tasks/main.yml"

output=$(python3 -c "import yaml, sys; yaml.safe_load(open('src/roles/vscode/tasks/main.yml'))" 2>&1)
assert_success "VSCode role is valid YAML"

assert_output_contains "VSCode role references AUR package" "visual-studio-code-bin" "$(cat src/roles/vscode/tasks/main.yml)"
assert_output_contains "VSCode role uses yay"               "yay"                    "$(cat src/roles/vscode/tasks/main.yml)"

# Verify AUR package exists and is published
if command -v curl >/dev/null 2>&1; then
  aur_response=$(curl -sf "https://aur.archlinux.org/rpc/v5/info?arg[]=visual-studio-code-bin")
  assert_success "AUR RPC reachable"
  aur_count=$(echo "$aur_response" | python3 -c "import sys,json; print(json.load(sys.stdin)['resultcount'])")
  assert_output_contains "visual-studio-code-bin found in AUR" "1" "$aur_count"
  aur_version=$(echo "$aur_response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['results'][0]['Version'])")
  echo "  AUR version: $aur_version"
else
  echo "SKIP: curl not available, skipping AUR check"
fi

echo "All VSCode feature tests passed!"
