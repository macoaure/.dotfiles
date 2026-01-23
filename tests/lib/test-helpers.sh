#!/bin/bash

# Test helper library for assertions and validations

# Assert that the last command succeeded
assert_success() {
    local message="$1"
    if [ $? -eq 0 ]; then
        echo "PASS: $message"
    else
        echo "FAIL: $message"
        exit 1
    fi
}

# Assert that the output contains a specific string
assert_output_contains() {
    local message="$1"
    local expected="$2"
    local actual="$3"
    if echo "$actual" | grep -q "$expected"; then
        echo "PASS: $message"
    else
        echo "FAIL: $message (expected '$expected' in output)"
        exit 1
    fi
}

# Assert that the output does NOT contain a specific string
assert_output_not_contains() {
    local message="$1"
    local unexpected="$2"
    local actual="$3"
    if ! echo "$actual" | grep -q "$unexpected"; then
        echo "PASS: $message"
    else
        echo "FAIL: $message (unexpected '$unexpected' in output)"
        exit 1
    fi
}

# Assert that a file exists
assert_file_exists() {
    local message="$1"
    local file="$2"
    if [ -f "$file" ]; then
        echo "PASS: $message"
    else
        echo "FAIL: $message (file '$file' does not exist)"
        exit 1
    fi
}

# Assert that a file is executable
assert_file_executable() {
    local message="$1"
    local file="$2"
    if [ -x "$file" ]; then
        echo "PASS: $message"
    else
        echo "FAIL: $message (file '$file' is not executable)"
        exit 1
    fi
}

# Run a command and capture its output
run_and_capture() {
    local cmd="$1"
    output=$(eval "$cmd" 2>&1)
    echo "$output"
}