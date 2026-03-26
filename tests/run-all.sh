#!/bin/bash

set -e

# Define project root precisely
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Parse arguments
VERBOSE=false
if [[ "$1" == "--verbose" ]]; then
  VERBOSE=true
fi

echo "🧪 Running all tests..."

# Feature tests (host-based)
echo "🔍 Feature tests..."
for test_script in tests/feature/*.sh; do
  if [ -x "$test_script" ]; then
    echo "Running $(basename "$test_script")..."
    if bash "$test_script"; then
      echo "✅ $(basename "$test_script") passed"
    else
      echo "❌ $(basename "$test_script") failed"
      exit 1
    fi
  fi
done
echo "✅ All feature tests passed"

# Unit and Integration tests on Arch Linux
image="archlinux:latest"
echo "🐳 Running tests on $image"

run_in_docker() {
  docker run --rm -v "$PROJECT_ROOT:/repo" "$image" bash -c "
    set -e
    cd /repo
    pacman -Syu --noconfirm --quiet && pacman -S --noconfirm --quiet ansible git stow 2>/dev/null
    echo '🧪 Unit tests...'
    bash tests/unit/test-syntax.sh
    echo '🔗 Integration tests...'
    bash tests/integration/test-full.sh
  "
}

if $VERBOSE; then
  if run_in_docker; then
    echo "✅ Tests passed on $image"
  else
    echo "❌ Tests failed on $image"
    exit 1
  fi
else
  if run_in_docker > /dev/null 2>&1; then
    echo "✅ Tests passed on $image"
  else
    echo "❌ Tests failed on $image"
    exit 1
  fi
fi

echo "🎉 All tests passed!"
