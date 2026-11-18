#!/usr/bin/env bats

load 'helpers'

setup_file() {
  cd "$DOTFILES_DIR"
  run bash install.sh
  export INSTALL_STATUS="$status"
  export INSTALL_OUTPUT="$output"
}

@test "install.sh exits 0" {
  [ "$INSTALL_STATUS" -eq 0 ]
}

@test "stow is available after install" {
  assert_command stow
}

@test "zsh is available after install" {
  assert_command zsh
}

@test "oh-my-zsh is installed" {
  [ -d "$HOME/.oh-my-zsh" ]
}

@test "zsh-syntax-highlighting plugin is installed" {
  [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]
}

@test "zsh-autosuggestions plugin is installed" {
  [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]
}
