#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()    { printf '\e[34m[info]\e[0m  %s\n' "$*"; }
success() { printf '\e[32m[ok]\e[0m    %s\n' "$*"; }
die()     { printf '\e[31m[error]\e[0m %s\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# 1. Core packages via pacman
# ---------------------------------------------------------------------------
info "Installing core packages via pacman..."
sudo pacman -S --needed --noconfirm zsh git stow curl base-devel

# ---------------------------------------------------------------------------
# 2. yay (AUR helper) — install if missing
# ---------------------------------------------------------------------------
if ! command -v yay &>/dev/null; then
  info "Installing yay..."
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
  (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi

# ---------------------------------------------------------------------------
# 3. AUR packages via yay
# ---------------------------------------------------------------------------
info "Installing AUR packages via yay..."
yay -S --needed --noconfirm mise-bin github-cli

# ---------------------------------------------------------------------------
# 4. pnpm
# ---------------------------------------------------------------------------
if ! command -v pnpm &>/dev/null; then
  info "Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# ---------------------------------------------------------------------------
# 5. Rust via rustup
# ---------------------------------------------------------------------------
if ! command -v rustup &>/dev/null; then
  info "Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# ---------------------------------------------------------------------------
# 6. oh-my-zsh
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ---------------------------------------------------------------------------
# 7. zsh plugins
# ---------------------------------------------------------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# ---------------------------------------------------------------------------
# 8. Stow all packages
# ---------------------------------------------------------------------------
info "Stowing packages..."
cd "$DOTFILES_DIR"
for pkg in packages/*/; do
  pkg_name="${pkg%/}"
  pkg_name="${pkg_name#packages/}"
  stow --dir=packages --target="$HOME" "$pkg_name" && success "stowed $pkg_name"
done

success "Done! Restart your shell or run: exec zsh"
