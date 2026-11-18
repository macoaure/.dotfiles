#!/usr/bin/env bats

load 'helpers'

@test "zsh sources .zshrc without errors" {
  run zsh -c "source $HOME/.zshrc"
  assert_success
}

@test ".zshrc exports .local/bin in PATH" {
  grep -q '\.local/bin' "$HOME/.zshrc"
}
