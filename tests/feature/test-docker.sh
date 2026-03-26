#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Docker role"

assert_file_exists "Docker role exists" "src/roles/docker/tasks/main.yml"

output=$(python3 -c "import yaml, sys; yaml.safe_load(open('src/roles/docker/tasks/main.yml'))" 2>&1)
assert_success "Docker role is valid YAML"

assert_output_contains "Docker role references docker package" "docker" "$(cat src/roles/docker/tasks/main.yml)"
assert_output_contains "Docker role enables systemd service" "systemd" "$(cat src/roles/docker/tasks/main.yml)"

echo "Docker installation logic validated"
echo "All Docker feature tests passed!"
