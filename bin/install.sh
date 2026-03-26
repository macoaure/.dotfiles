#!/bin/bash

set -e

REPO_URL="https://github.com/macoaure/.dotfiles.git"
REPO_WEB="https://github.com/macoaure/.dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

# ── Colors ────────────────────────────────────────────────────────────────────
R='\033[0;31m'  G='\033[0;32m'  Y='\033[1;33m'
B='\033[0;34m'  C='\033[0;36m'  W='\033[1;37m'  D='\033[2m'  NC='\033[0m'

# ── Helpers ───────────────────────────────────────────────────────────────────
box() {
    local msg="$1" width=50
    local pad=$(( (width - ${#msg}) / 2 ))
    echo -e "${B}  ╔$(printf '═%.0s' $(seq 1 $width))╗${NC}"
    echo -e "${B}  ║${NC}$(printf ' %.0s' $(seq 1 $pad))${W}${msg}${NC}$(printf ' %.0s' $(seq 1 $(( width - pad - ${#msg} ))))${B}║${NC}"
    echo -e "${B}  ╚$(printf '═%.0s' $(seq 1 $width))╝${NC}"
}

step()    { echo -e "\n${B}[${W}$1${B}/${W}$2${B}]${NC} ${W}$3${NC}"; }
ok()      { echo -e "  ${G}✓${NC} $1"; }
info()    { echo -e "  ${D}→${NC} $1"; }
warn()    { echo -e "  ${Y}!${NC} $1"; }
fail()    { echo -e "  ${R}✗${NC} $1"; exit 1; }
ask()     { echo -e "\n  ${C}?${NC} $1"; }

# ── Header ────────────────────────────────────────────────────────────────────
clear
echo ""
box "  macoaure/.dotfiles  "
echo -e "  ${D}personal environment as infrastructure${NC}"
echo ""

# ── Step 1: System check ──────────────────────────────────────────────────────
step 1 5 "Checking system requirements"

if ! command -v pacman &>/dev/null; then
    fail "Arch Linux required (pacman not found). Aborting."
fi
ok "Arch Linux detected"

# ── Step 2: Dependencies ──────────────────────────────────────────────────────
step 2 5 "Installing dependencies"

if ! command -v git &>/dev/null; then
    info "Installing git..."
    sudo pacman -S --noconfirm git &>/dev/null
fi
ok "git"

if ! command -v ansible-playbook &>/dev/null; then
    info "Installing ansible..."
    sudo pacman -S --noconfirm ansible &>/dev/null
fi
ok "ansible"

# ── Step 3: Clone ─────────────────────────────────────────────────────────────
step 3 5 "Setting up repository"

if [ ! -d "$DOTFILES_DIR" ]; then
    info "Cloning $REPO_URL..."
    git clone "$REPO_URL" "$DOTFILES_DIR" &>/dev/null
    ok "Cloned to $DOTFILES_DIR"
else
    warn "Directory $DOTFILES_DIR already exists — skipping clone"
    ok "Using existing repository"
fi

cd "$DOTFILES_DIR"

# ── Step 4: Role selection ────────────────────────────────────────────────────
step 4 5 "Role selection"

ALL_ROLES=(base aur-helper zsh docker mise vscode cursor claude-code codex gemini rtk stow)

ask "Installation mode:\n\n  ${W}[1]${NC} Full install (all roles)\n  ${W}[2]${NC} Custom (choose roles)\n"
read -rp "  → " mode

SELECTED_TAGS=""

if [[ "$mode" == "2" ]]; then
    echo ""
    echo -e "  ${D}Space to toggle, Enter to confirm:${NC}\n"
    selected=()
    for role in "${ALL_ROLES[@]}"; do
        read -rp "  Include ${W}${role}${NC}? [Y/n] " ans
        if [[ "$ans" != "n" && "$ans" != "N" ]]; then
            selected+=("$role")
        fi
    done
    SELECTED_TAGS=$(IFS=','; echo "${selected[*]}")
    info "Selected: $SELECTED_TAGS"
else
    ok "Full install selected"
fi

# ── Step 5: Run playbook ──────────────────────────────────────────────────────
step 5 5 "Running Ansible playbook"
echo ""

if [[ -n "$SELECTED_TAGS" ]]; then
    ansible-playbook src/setup.yml --ask-become-pass --tags "$SELECTED_TAGS"
else
    ansible-playbook src/setup.yml --ask-become-pass
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
box "  Installation complete!  "
echo ""
echo -e "  ${G}Your environment is ready.${NC}"
echo -e "  Backups saved to ${D}~/.dotfiles-backups/${NC}"
echo ""

# ── Star prompt ───────────────────────────────────────────────────────────────
echo -e "  ${Y}★${NC}  Found this useful? Star it on GitHub:"
echo -e "  ${C}${REPO_WEB}${NC}"
echo ""
read -rp "  [Enter] open in browser  [s] skip: " star_choice

if [[ "$star_choice" != "s" && "$star_choice" != "S" ]]; then
    if command -v xdg-open &>/dev/null; then
        xdg-open "$REPO_WEB" &>/dev/null &
        ok "Opening in browser..."
    else
        info "Visit the link above to star the project."
    fi
fi

echo ""
