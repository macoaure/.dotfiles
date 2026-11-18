# p10k instant prompt — must be near the top, before any output
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
HIST_STAMPS="yyyy-mm-dd"
COMPLETION_WAITING_DOTS="true"

# zsh-syntax-highlighting must come before history-substring-search in the list
plugins=(
  git
  z
  sudo
  extract
  colored-man-pages
  copypath
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
)

# zsh-completions: extend fpath before OMZ calls compinit
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Completion styles
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

source $ZSH/oh-my-zsh.sh

# ── Environment ───────────────────────────────────────────────────────────────
export EDITOR="code"

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# History substring search bindings (plugin loaded above)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── Key Bindings ──────────────────────────────────────────────────────────────
bindkey '^[[1;5C' forward-word       # Ctrl+Right  — jump word forward
bindkey '^[[1;5D' backward-word      # Ctrl+Left   — jump word backward
bindkey '^H'      backward-kill-word # Ctrl+Backspace — delete previous word

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# pnpm global bin
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# ── mise ──────────────────────────────────────────────────────────────────────
eval "$($HOME/.local/bin/mise activate zsh)"

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias zshconfig='$EDITOR ~/.zshrc'  # open this file in the current editor

# ── Listing ───────────────────────────────────────────────────────────────────
# Prefer eza (modern ls replacement) when available
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias la='eza -a --icons'
  alias ll='eza -lah --icons --git'
  alias lt='eza --tree --icons -L 3'
else
  alias ls='ls -A --color=auto'
  alias la='ls -a --color=auto'
  alias ll='ls -lah --color=auto'
fi
command -v bat    &>/dev/null && alias cat='bat --paging=never'
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ── File Operations ───────────────────────────────────────────────────────────
alias cp='cp -iv'      # prompt before overwrite, show what was copied
alias mv='mv -iv'      # prompt before overwrite, show what was moved
alias mkdir='mkdir -pv' # create intermediate dirs, show what was created

# ── History Shortcuts ─────────────────────────────────────────────────────────
alias h='history'
alias h1='history 10'
alias h2='history 20'
alias h3='history 30'
alias hgrep='history | grep'

# ── System ────────────────────────────────────────────────────────────────────
alias c='clear'
alias q='exit'
alias quit='exit'
alias top='htop'                     # better process viewer
alias mem='free -h'                  # human-readable memory usage
alias disk='df -h'                   # human-readable disk usage
alias cpu='lscpu'                    # CPU info
alias ports='netstat -tulanp'        # all listening ports
alias myip='curl -s ifconfig.me'     # public IP address
alias ping='ping -c 5'               # limit to 5 packets
alias wget='wget -c'                 # always resume partial downloads
alias timestamp='date +%Y%m%d%H%M%S'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# ── Python ────────────────────────────────────────────────────────────────────
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# ── Tool Updates ──────────────────────────────────────────────────────────────
alias miseup='mise upgrade'

# ── Git ───────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias add='git add .'
alias clone='git clone'
alias pull='git pull'
alias checkout='git checkout'
alias commit='git commit -m'

# ── p10k ──────────────────────────────────────────────────────────────────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ── Weather (p10k segment) ────────────────────────────────────────────────────
# City used for all weather lookups. Override in ~/.zshenv before sourcing this.
WEATHER_CITY="${WEATHER_CITY:-Londrina}"
_WEATHER_CACHE="$HOME/.cache/weather_p10k"

# Fetch wttr.in JSON, build "⛅ 23°C ▁▂▄▆▇▇▅▃ 18–29°C", write to cache.
# Always called in background — never blocks the prompt.
function _weather_refresh_cache() {
  local json
  json=$(curl -s --connect-timeout 3 "wttr.in/${WEATHER_CITY}?format=j1" 2>/dev/null) || return
  [[ -z "$json" ]] && return

  local display
  display=$(echo "$json" | python3 -c "
import json, sys

data = json.load(sys.stdin)
cc   = data['current_condition'][0]
temp = cc.get('temp_C', '?')

# Map weatherCode to a Unicode symbol
code = int(cc.get('weatherCode', 0))
if   code == 113:                               sym = '☀'
elif code in (116, 119, 122):                   sym = '⛅'
elif code in (143, 248, 260):                   sym = '🌫'
elif code in (200, 386, 389, 392, 395):         sym = '⛈'
elif code in (179, 182, 227, 230, 323, 326,
              329, 332, 335, 338, 350, 371):    sym = '❄'
else:                                           sym = '🌧'

print(f'{sym} {temp}°C')
" 2>/dev/null) || return

  [[ -n "$display" ]] && echo "$display" >| "$_WEATHER_CACHE"
}

# p10k custom segment: instant (file read only), triggers background refresh when stale.
# Add 'my_weather' to POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS in ~/.p10k.zsh to enable.
function prompt_my_weather() {
  zmodload zsh/datetime 2>/dev/null
  if [[ ! -f "$_WEATHER_CACHE" ]] ||
     (( EPOCHSECONDS - $(stat -c %Y "$_WEATHER_CACHE" 2>/dev/null || echo 0) > 14400 )); then
    _weather_refresh_cache &!
  fi
  [[ -f "$_WEATHER_CACHE" ]] || return
  p10k segment -f 39 -t "$(< "$_WEATHER_CACHE")"
}

# ── Functions ─────────────────────────────────────────────────────────────────

# Reload this file without opening a new shell
function reload() {
  source "$HOME/.zshrc"
}

# Override cd to show git status when entering a repository
function cd() {
  builtin cd "$@"
  [[ -d .git ]] && git status
}

# Create a directory and enter it in one step
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find files by partial name under the current directory
function findfile() {
  find . -name "*$1*" -type f
}

# Quick weather report — defaults to Londrina, accepts an optional city arg
function weather() {
  local city="${1:-Londrina}"
  curl -s "wttr.in/$city?format=3"
}
