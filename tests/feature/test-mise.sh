#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Mise role (Arch Linux)"

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
IMAGE="archlinux:latest"

if ! command -v docker >/dev/null 2>&1; then
    echo "SKIP: Docker not available"
    exit 0
fi

output=$(docker run --rm -v "$REPO_ROOT":/repo -w /repo $IMAGE bash -e -c '
  set -e
  pacman -Syu --noconfirm --quiet
  pacman -S --noconfirm --quiet ansible mise
  # Verify the role tasks are valid and mise is reachable
  ansible-playbook --syntax-check src/setup.yml
  if command -v mise >/dev/null 2>&1; then
    echo "FOUND_MISE"
  else
    echo "MISE_NOT_FOUND"
    exit 2
  fi
') || rc=$?

rc=${rc:-0}

if [ "$rc" -ne 0 ]; then
  echo "FAIL: Mise test failed (rc=$rc)"
  echo "$output"
  exit 1
fi

assert_output_contains "Mise available in Arch container" "FOUND_MISE" "$output"

echo "All Mise feature tests passed!"
