#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Mise installation in Docker"

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
IMAGE="ubuntu:22.04"

# Skip if Docker is not available on the host
if ! command -v docker >/dev/null 2>&1; then
    echo "SKIP: Docker not available, skipping mise Docker test"
    exit 0
fi

# Run in container: install ansible, then run only the 'mise' tagged tasks
output=$(docker run --rm -v "$REPO_ROOT":/repo -w /repo $IMAGE bash -e -c '
  set -e
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq curl gnupg ca-certificates python3 python3-pip
  pip3 install --no-cache-dir ansible
  # Run mise installation tag
  ansible-playbook src/setup.yml --tags mise -c local -i localhost, --connection=local --extra-vars "ansible_python_interpreter=/usr/bin/python3"
  if command -v mise >/dev/null 2>&1; then
    echo "FOUND_MISE"
  else
    echo "MISE_NOT_FOUND"
    exit 2
  fi
') || rc=$?

# Capture exit code
rc=${rc:-0}

if [ "$rc" -ne 0 ]; then
  echo "FAIL: Docker mise install run failed (rc=$rc)"
  echo "$output"
  exit 1
fi

# Verify we found mise
assert_output_contains "Mise installed in container" "FOUND_MISE" "$output"

echo "All Mise Docker feature tests passed!"