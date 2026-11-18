#!/usr/bin/env bats

load 'helpers'

setup_file() {
  cd "$DOTFILES_DIR"
  for pkg in packages/*/; do
    pkg_name="${pkg%/}"; pkg_name="${pkg_name#packages/}"
    stow --dir=packages --target="$HOME" "$pkg_name"
  done
}

@test ".zshrc is symlinked" {
  assert_symlink "$HOME/.zshrc"
}

@test ".gitconfig is symlinked" {
  assert_symlink "$HOME/.gitconfig"
}

@test "mise config is symlinked" {
  assert_symlink "$HOME/.config/mise/config.toml"
}

@test "htoprc is symlinked" {
  assert_symlink "$HOME/.config/htop/htoprc"
}

@test "no broken symlinks in HOME" {
  run find "$HOME" -maxdepth 3 -xtype l
  assert_output ""
}
