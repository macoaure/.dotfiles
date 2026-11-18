#!/usr/bin/env bats

load 'helpers'

@test "zsh sources .zshrc without errors" {
  run zsh -c "source $HOME/.zshrc"
  assert_success
}

@test ".zshrc sets PATH to include .local/bin" {
  run zsh -c "source $HOME/.zshrc && echo \$PATH"
  assert_output --partial ".local/bin"
}
