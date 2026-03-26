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
[[ -t 1 ]] && clear
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
    info "Updating existing repository..."
    git -C "$DOTFILES_DIR" pull --ff-only &>/dev/null \
        && ok "Repository updated" \
        || warn "Could not fast-forward — local changes may be present. Proceeding with current state."
fi

cd "$DOTFILES_DIR"

# ── Step 4: Role selection ────────────────────────────────────────────────────
step 4 5 "Role selection"

ALL_ROLES=(base aur-helper zsh docker mise vscode cursor claude-code codex gemini rtk stow)

ask "Installation mode:\n\n  ${W}[1]${NC} Full install (all roles)\n  ${W}[2]${NC} Custom (choose roles)\n"
printf "  → " > /dev/tty
read -r mode < /dev/tty

SELECTED_TAGS=""

if [[ "$mode" == "2" ]]; then
    echo ""
    echo -e "  ${D}Space to toggle, Enter to confirm:${NC}\n"
    selected=()
    for role in "${ALL_ROLES[@]}"; do
        printf "  Include ${W}${role}${NC}? [Y/n] " > /dev/tty
        read -r ans < /dev/tty
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

# Ask for sudo password upfront so ansible runs non-interactively in background
# Force read/write to /dev/tty — works even when stdin is a pipe (curl | bash)
echo -ne "  ${D}[sudo] become password: ${NC}" > /dev/tty
read -rs become_pass < /dev/tty
echo "" > /dev/tty
[[ -z "$become_pass" ]] && fail "Password cannot be empty."

tag_args=()
[[ -n "$SELECTED_TAGS" ]] && tag_args=(--tags "$SELECTED_TAGS")

# Count total tasks for progress bar
info "Preparing..."
total=$(ANSIBLE_FORCE_COLOR=0 ansible-playbook src/setup.yml \
    -e "ansible_become_pass=$become_pass" \
    --list-tasks "${tag_args[@]}" 2>/dev/null \
    | grep -cE "^\s{6}" || true)
[[ "$total" -lt 1 ]] && total=1

# Progress bar renderer (loop-based to support UTF-8 multibyte chars)
_bar() {
    local current=$1 total=$2 width=36
    local pct=$(( current * 100 / total ))
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))
    local bar="" i task

    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done

    task=$(grep -oP "(?<=TASK \[)[^\]]+" "$_tmpfile" 2>/dev/null | tail -1 | cut -c1-32)

    printf "\r  ${B}[${NC}%s${B}]${NC} ${W}%3d%%${NC}  ${D}%-32s${NC}" "$bar" "$pct" "$task"
}

# Run ansible in background, capture output
_tmpfile=$(mktemp)
_logfile="$HOME/.dotfiles-install.log"
trap 'rm -f "$_tmpfile"' EXIT

ANSIBLE_FORCE_COLOR=0 ansible-playbook src/setup.yml \
    -e "ansible_become_pass=$become_pass" \
    "${tag_args[@]}" > "$_tmpfile" 2>&1 &
_pid=$!

echo ""
_current=0
_fatal_detected=0
while kill -0 "$_pid" 2>/dev/null; do
    _current=$(grep -cE "^(ok|changed|skipping|fatal):" "$_tmpfile" 2>/dev/null || true)
    [[ "$_current" -gt "$total" ]] && _current=$total
    _bar "$_current" "$total"

    # Detect fatal errors early — no need to keep waiting
    if grep -qE "^fatal:" "$_tmpfile" 2>/dev/null; then
        _fatal_detected=1
        break
    fi

    sleep 0.15
done

wait "$_pid"; _rc=$?
# Clear the progress bar line before any output
printf "\r\033[K"

if [[ "$_rc" -ne 0 ]] || [[ "$_fatal_detected" -ne 0 ]]; then
    # Save full log before the tmpfile is cleaned up
    cp "$_tmpfile" "$_logfile"

    echo -e "  ${R}✗ Ansible failed${NC}\n"

    # Show failing task and error context
    if grep -qE "^fatal:" "$_tmpfile" 2>/dev/null; then
        echo -e "  ${Y}Failing task:${NC}"
        grep -B2 "^fatal:" "$_tmpfile" | grep "^TASK" | tail -1 | sed 's/^/    /'
        echo ""
        echo -e "  ${Y}Error:${NC}"
        grep -A3 "^fatal:" "$_tmpfile" | head -20 | sed 's/^/    /'
        echo ""
    fi

    echo -e "  ${D}Full log saved to: ${W}$_logfile${NC}"
    echo -e "  ${D}Run ${W}cat $_logfile${D} to see complete output.${NC}\n"
    exit 1
fi
ok "Playbook completed"

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
printf "  [Enter] open in browser  [s] skip: " > /dev/tty
read -r star_choice < /dev/tty

if [[ "$star_choice" != "s" && "$star_choice" != "S" ]]; then
    if command -v xdg-open &>/dev/null; then
        xdg-open "$REPO_WEB" &>/dev/null &
        ok "Opening in browser..."
    else
        info "Visit the link above to star the project."
    fi
fi

echo ""
