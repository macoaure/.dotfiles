#!/usr/bin/env bats

load 'helpers'

@test ".zshrc is symlinked" {
  assert_symlink "$HOME/.zshrc"
}

@test ".gitconfig is symlinked" {
  assert_symlink "$HOME/.gitconfig"
}

@test "mise config dir is symlinked" {
  assert_symlink "$HOME/.config/mise"
}

@test "htop config dir is symlinked" {
  assert_symlink "$HOME/.config/htop"
}

@test "no broken symlinks in HOME" {
  run find "$HOME" -maxdepth 3 -xtype l
  assert_output ""
}
