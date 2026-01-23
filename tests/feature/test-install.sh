#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Install Script"

assert_file_exists "Install script exists" "bin/install.sh"
assert_file_executable "Install script is executable" "bin/install.sh"