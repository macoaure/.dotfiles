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

# Unit and Integration tests on multiple OS
images=("ubuntu:20.04" "archlinux:latest")

for image in "${images[@]}"; do
  echo "🐳 Running tests on $image"
  if $VERBOSE; then
    # Verbose mode: show all output
    if docker run --rm -v "$PROJECT_ROOT:/repo" $image bash -c "
      set -e
      cd /repo
      # Install dependencies based on OS (quiet mode)
      if command -v apt &> /dev/null; then
        apt update -qq && apt install -y -qq ansible git stow python3-apt
      elif command -v pacman &> /dev/null; then
        pacman -Syu --noconfirm --quiet && pacman -S --noconfirm --quiet ansible git stow
      fi
      # Run unit tests
      echo '🧪 Unit tests...'
      bash tests/unit/test-syntax.sh
      # Run integration tests
      echo '🔗 Integration tests...'
      bash tests/integration/test-full.sh
    "; then
      echo "✅ Tests passed on $image"
    else
      echo "❌ Tests failed on $image"
      exit 1
    fi
  else
    # Quiet mode: suppress installation output, show only results
    if docker run --rm -v "$PROJECT_ROOT:/repo" $image bash -c "
      set -e
      cd /repo
      # Install dependencies based on OS (quiet mode)
      if command -v apt &> /dev/null; then
        apt update -qq && apt install -y -qq ansible git stow python3-apt
      elif command -v pacman &> /dev/null; then
        pacman -Syu --noconfirm --quiet && pacman -S --noconfirm --quiet ansible git stow
      fi
      # Run unit tests
      echo '🧪 Unit tests...'
      bash tests/unit/test-syntax.sh
      # Run integration tests
      echo '🔗 Integration tests...'
      bash tests/integration/test-full.sh
    " > /dev/null 2>&1; then
      echo "✅ Tests passed on $image"
    else
      echo "❌ Tests failed on $image"
      exit 1
    fi
  fi
done

echo "🎉 All tests passed!"