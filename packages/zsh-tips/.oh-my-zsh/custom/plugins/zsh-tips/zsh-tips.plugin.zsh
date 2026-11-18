# zsh-tips: shows a faded tip after the terminal is idle
# Configurable: ZSH_TIPS_TIMEOUT (seconds, default 20)
#               ZSH_TIPS_ENABLED (true/false, default true)

# Guard: only initialise once per shell session so re-sourcing .zshrc
# does not rebuild the TRAPALRM chain and cause recursion.
(( ${+_ZSH_TIPS_LOADED} )) && return 0
typeset -g _ZSH_TIPS_LOADED=1

typeset -g  ZSH_TIPS_TIMEOUT=${ZSH_TIPS_TIMEOUT:-20}
typeset -g  ZSH_TIPS_ENABLED=${ZSH_TIPS_ENABLED:-true}

typeset -ga ZSH_TIPS=(
  # Navigation
  "Ctrl+R          — search command history interactively (type to filter)"
  "Ctrl+L          — clear the screen without losing your current input"
  "Ctrl+U          — delete everything before the cursor on this line"
  "Ctrl+W          — delete the word immediately before the cursor"
  "Ctrl+A / Ctrl+E — jump to the start / end of the line"
  "Alt+B / Alt+F   — jump one word backward / forward"
  "Ctrl+X Ctrl+E   — open the current command in \$EDITOR to finish writing it"

  # History tricks
  "!!              — repeat the last command exactly as typed"
  "!$              — expand to the last argument of the previous command"
  "Alt+.           — insert the last argument of the previous command"
  "^old^new        — rerun the last command replacing 'old' with 'new'"
  "!pattern        — run the most recent command that starts with 'pattern'"
  "fc              — open the last command in \$EDITOR and re-run it on save"

  # Job control
  "Ctrl+Z          — suspend the foreground process"
  "fg              — bring the last suspended job back to the foreground"
  "bg              — resume the last suspended job in the background"
  "jobs            — list all suspended and background jobs"
  "disown %1       — detach job 1 from the shell so it survives logout"

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
  "echo \${VAR:-default}   — print 'default' if VAR is unset or empty"
  "time command            — measure how long a command takes to run"
  "watch -n2 command       — re-run a command every 2 seconds"
  "Ctrl+C then !!          — cancel the current command and immediately retry it"
)

_zsh_tips_show() {
  [[ "$ZSH_TIPS_ENABLED" == true ]] || return
  local idx=$(( RANDOM % ${#ZSH_TIPS[@]} + 1 ))
  local tip="${ZSH_TIPS[$idx]}"
  # Escape literal % signs so print -P doesn't treat them as prompt sequences
  local safe="${tip:gs/%/%%}"
  local msg
  print -Pv msg -- "%F{242} 💡  ${safe}%f"
  # zle -I signals ZLE that we're printing to the terminal directly;
  # it redraws cleanly on the next keystroke. zle -M is avoided because
  # it treats its string as literal text and does not render ANSI codes.
  zle -I
  print -- "$msg"
}

TRAPALRM() {
  _zsh_tips_show
}

# Only shorten TMOUT if unset or already larger than our threshold
if [[ -z "${TMOUT:-}" ]] || (( TMOUT > ZSH_TIPS_TIMEOUT )); then
  TMOUT=$ZSH_TIPS_TIMEOUT
fi
