#!/usr/bin/env bats

load 'helpers'

setup() {
  export PNPM_HOME="$HOME/.local/share/pnpm"
  export PATH="$HOME/.local/share/mise/shims:$HOME/.cargo/bin:$HOME/.local/bin:$PNPM_HOME/bin:$PATH"
}

@test "mise is available" {
  assert_command mise
}

@test "gh is available" {
  assert_command gh
}

@test "pnpm is available" {
  assert_command pnpm
}

@test "rustc is available" {
  assert_command rustc
}

@test "gitmoji is available" {
  assert_command gitmoji
}

@test "gitmoji-changelog is available" {
  assert_command gitmoji-changelog
}

@test "git is available" {
  assert_command git
}
