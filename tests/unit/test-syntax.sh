#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Unit: Syntax Check"

output=$(ansible-playbook --syntax-check src/setup.yml)

assert_success "Ansible syntax check"
assert_output_contains "Syntax check output" "playbook: src/setup.yml" "$output"