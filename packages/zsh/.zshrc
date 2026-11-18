# p10k instant prompt — must be near the top, before any output
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

HIST_STAMPS="yyyy-mm-dd"
COMPLETION_WAITING_DOTS="true"

# zsh-syntax-highlighting must precede history-substring-search
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
  zsh-tips
)

source $ZSH/oh-my-zsh.sh

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# ── mise ──────────────────────────────────────────────────────────────────────
eval "$($HOME/.local/bin/mise activate zsh)"

# ── Modern tool aliases (activate once binaries are installed) ────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons --git'
  alias lt='eza --tree --icons -L 3'
else
  alias ll='ls -lah'
fi
command -v bat    &>/dev/null && alias cat='bat --paging=never'
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ── Navigation ────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Git ───────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'

# To customise the prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
