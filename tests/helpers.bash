load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

DOTFILES_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
PACKAGES_DIR="$DOTFILES_DIR/packages"

assert_symlink() {
  local target="$1"
  [[ -L "$target" ]] || fail "expected symlink at $target"
}

assert_command() {
  run command -v "$1"
  assert_success
}
