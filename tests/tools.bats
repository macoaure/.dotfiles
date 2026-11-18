#!/usr/bin/env bats

load 'helpers'

@test "mise is available" {
  assert_command mise
}

@test "gh is available" {
  assert_command gh
}

@test "pnpm is available" {
  assert_command pnpm
}

@test "rustup is available" {
  assert_command rustup
}

@test "git is available" {
  assert_command git
}
