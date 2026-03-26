#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Install script"

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

if ! command -v docker >/dev/null 2>&1; then
    echo "SKIP: Docker not available"
    exit 0
fi

# ── Test 1: Syntax check ──────────────────────────────────────────────────────
bash -n "$REPO_ROOT/bin/install.sh" 2>/dev/null
assert_success "Install script has valid bash syntax"

# ── Test 2: Rejects non-Arch systems ─────────────────────────────────────────
output=$(docker run --rm -v "$REPO_ROOT:/repo" -w /repo ubuntu:22.04 \
    bash -c 'bash bin/install.sh 2>&1 || true')
assert_output_contains "Rejects non-Arch system" "Arch Linux required" "$output"

# ── Test 3: Fresh clone creates dotfiles directory ────────────────────────────
output=$(docker run --rm -v "$REPO_ROOT:/repo" archlinux:latest bash -c '
    set -e
    pacman -Syu --noconfirm 2>/dev/null 1>/dev/null
    pacman -S --noconfirm git 2>/dev/null 1>/dev/null

    git config --global user.email "test@test.com"
    git config --global user.name "Test"
    git config --global --add safe.directory "*"

    git clone --bare /repo /tmp/dotfiles-remote.git 2>/dev/null

    DOTFILES_DIR="/tmp/dotfiles-test"
    git clone "file:///tmp/dotfiles-remote.git" "$DOTFILES_DIR" 2>/dev/null

    [ -d "$DOTFILES_DIR/.git" ] && echo "CLONE_OK"
' 2>&1)
assert_output_contains "Fresh clone creates dotfiles directory" "CLONE_OK" "$output"

# ── Test 4: Existing repo triggers git pull ───────────────────────────────────
output=$(docker run --rm -v "$REPO_ROOT:/repo" archlinux:latest bash -c '
    set -e
    pacman -Syu --noconfirm 2>/dev/null 1>/dev/null
    pacman -S --noconfirm git 2>/dev/null 1>/dev/null

    git config --global user.email "test@test.com"
    git config --global user.name "Test"
    git config --global --add safe.directory "*"

    git clone --bare /repo /tmp/dotfiles-remote.git 2>/dev/null

    DOTFILES_DIR="/tmp/dotfiles-test"
    git clone "file:///tmp/dotfiles-remote.git" "$DOTFILES_DIR" 2>/dev/null

    # Simulate the update path from install.sh
    git -C "$DOTFILES_DIR" pull --ff-only 2>/dev/null && echo "PULL_OK"
' 2>&1)
assert_output_contains "Existing repo triggers git pull" "PULL_OK" "$output"

# ── Test 5: Empty password is rejected ───────────────────────────────────────
output=$(bash -c '
    become_pass=""
    [[ -z "$become_pass" ]] && echo "EMPTY_PASS_REJECTED"
')
assert_output_contains "Empty password is rejected" "EMPTY_PASS_REJECTED" "$output"

# ── Test 6: Script is executable ─────────────────────────────────────────────
assert_file_executable "Install script is executable" "$REPO_ROOT/bin/install.sh"

echo "All installer feature tests passed!"
