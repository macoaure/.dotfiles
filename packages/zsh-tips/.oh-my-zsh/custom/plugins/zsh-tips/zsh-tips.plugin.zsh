# zsh-tips: shows a faded tip after the terminal is idle
# Configurable: ZSH_TIPS_TIMEOUT (seconds, default 20)
#               ZSH_TIPS_ENABLED (true/false, default true)

# Guard: only initialise once per shell session so re-sourcing .zshrc
# does not rebuild the TRAPALRM chain and cause recursion.
(( ${+_ZSH_TIPS_LOADED} )) && return 0
typeset -g _ZSH_TIPS_LOADED=1

typeset -g  ZSH_TIPS_TIMEOUT=${ZSH_TIPS_TIMEOUT:-5}
typeset -g  ZSH_TIPS_ENABLED=${ZSH_TIPS_ENABLED:-true}

typeset -ga ZSH_TIPS=(
  # Navigation
  "Ctrl+R          — search command history interactively (type to filter)"
  "Ctrl+L          — clear the screen without losing your current input"
  "Ctrl+U          — delete everything before the cursor on this line"
  "Ctrl+W          — delete the word immediately before the cursor"
  "Ctrl+A / Ctrl+E — jump to the start / end of the line"
  "Alt+B / Alt+F   — jump one word backward / forward"
  "Ctrl+X Ctrl+E   — open the current command in your editor to finish writing it"

  # History tricks
  "!!              — repeat the last command exactly as typed"
  "!$              — expand to the last argument of the previous command"
  "Alt+.           — insert the last argument of the previous command"
  "^old^new        — rerun the last command replacing 'old' with 'new'"
  "!pattern        — run the most recent command that starts with 'pattern'"
  "fc              — open the last command in your editor and re-run it on save"

  # Job control
  "Ctrl+Z          — suspend the foreground process"
  "fg              — bring the last suspended job back to the foreground"
  "bg              — resume the last suspended job in the background"
  "jobs            — list all suspended and background jobs"
  "disown %%1      — detach job 1 from the shell so it survives logout"

  # Redirection & pipes
  "command 2>&1    — merge stderr into stdout"
  "command &> file — redirect both stdout and stderr to a file"
  "tee file        — write stdin to both stdout and a file simultaneously"
  "command | less  — page through any long output"

  # Files & directories
  "cd -            — go back to the previous directory"
  "mkdir -p a/b/c  — create nested directories in one command"
  "cp file{,.bak}  — quickly duplicate a file with a .bak suffix"
  "find . -name '*.log' -delete — delete all .log files recursively"
  "du -sh *        — see the disk usage of every item in the current directory"

  # zsh-specific
  "In zsh: **/*.ts — recursively glob all .ts files under the current directory"
  "In zsh: = cmd   — expand a command name to its full path (e.g. =python)"
  "In zsh: take dir — create a directory and cd into it (oh-my-zsh alias)"
  "In zsh: type a partial command then press Up — searches history by prefix"
  "In zsh: setopt NO_CASE_GLOB — make glob matching case-insensitive"

  # Useful shortcuts
  "echo value      — use :- to provide a fallback when a variable is unset"
  "time command    — measure how long a command takes to run"
  "watch -n2 cmd   — re-run a command every 2 seconds and show the output"
  "Ctrl+C then !!  — cancel the current command and immediately retry it"
)

# Restore RPROMPT before the next command runs.
_zsh_tips_restore() {
  [[ -v _ZSH_TIPS_RPROMPT_ORIG ]] || return
  RPROMPT="${_ZSH_TIPS_RPROMPT_ORIG}"
  unset _ZSH_TIPS_RPROMPT_ORIG
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec _zsh_tips_restore

# zle reset-prompt must be called directly in TRAPALRM, not in a subfunction.
TRAPALRM() {
  [[ "$ZSH_TIPS_ENABLED" == true ]] || return
  local idx=$(( RANDOM % ${#ZSH_TIPS[@]} + 1 ))
  local display="${ZSH_TIPS[$idx]:gs/%/%%}"
  typeset -g _ZSH_TIPS_RPROMPT_ORIG="${RPROMPT}"
  RPROMPT="%F{242} 💡 ${display}%f"
  zle reset-prompt
}

# Only shorten TMOUT if unset or already larger than our threshold
if [[ -z "${TMOUT:-}" ]] || (( TMOUT > ZSH_TIPS_TIMEOUT )); then
  TMOUT=$ZSH_TIPS_TIMEOUT
fi
