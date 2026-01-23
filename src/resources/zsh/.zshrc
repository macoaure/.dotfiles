#!/usr/bin/env zsh

alias zshconfig="code ~/.zshrc"
alias ..="cd .."
alias ...="cd ../.."
alias wget="wget -c"
alias l="ls --color=auto"
alias l='ls -lAh --color=auto'
alias ls="ls -A --color=auto"
alias la="ls -a --color=auto"
alias ll="ls -al --color=auto"
alias h="history"
alias h1="history 10"
alias h2="history 20"
alias h3="history 30"
alias hgrep='history | grep'
alias mkdir="mkdir -pv"
alias q="exit"
alias quit="exit"
alias ping="ping -c 5"
alias myip="curl -s ifconfig.me"
alias c="clear"
alias brewup="brew update && brew upgrade"
alias miseup="mise upgrade"
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ports="netstat -tulanp"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"
alias py="python3"
alias pip="pip3"
alias venv="python3 -m venv"
alias activate="source venv/bin/activate"
# alias deactivate="deactivate"
alias top="htop"
alias mem="free -h"
alias disk="df -h"
alias cpu="lscpu"
alias timestamp="date +%Y%m%d%H%M%S"
alias add="git add ."
alias checkout="git checkout"
alias clone="git clone"
alias commit="git commit -m"
alias pull="git pull"

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR="code"

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word

if [ -f ~/.local/bin/mise ]; then
    eval "$(~/.local/bin/mise activate zsh)"
fi

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
    sudo git macos vscode history command-not-found copypath cp thefuck
    colorize safe-paste systemadmin aliases git
)

if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
    plugins+=(zsh-syntax-highlighting)
fi

if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    plugins+=(zsh-autosuggestions)
fi

if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]]; then
    plugins+=(zsh-history-substring-search)
fi

if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autocomplete ]]; then
    plugins+=(zsh-autocomplete)
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit
source "$ZSH/oh-my-zsh.sh"


function reload() {
    source $HOME/.zshrc
}


# function cd() {
#     builtin cd "$@"
#     if [ ! -d .git ]; then
#         return
#     else
#         git status
#     fi
# }


function extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) unrar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function mkcd() {
    mkdir -p "$1" && cd "$1"
}

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

function findfile() {
    find . -name "*$1*" -type f
}

function weather() {
    CITY="Londrina"
    curl -s "wttr.in/$CITY?format=3"
}

export PATH=$PATH:/home/vector/.local/share/mise/installs/php/8.4.13/bin:/home/vector/.local/share/mise/installs/php/8.4.13/.composer/vendor/bin

# Set Ghostty as default terminal if available
if command -v ghostty >/dev/null 2>&1; then
    export TERMINAL=ghostty
fi
