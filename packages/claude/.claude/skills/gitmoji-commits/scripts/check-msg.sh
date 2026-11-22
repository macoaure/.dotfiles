#!/bin/sh
# usage: check-msg.sh "<subject line>"  — exits 1 unless ":shortcode: type(scope): subject"
echo "$1" | grep -qE '^:[a-z0-9_-]+: (feat|feature|fix|bug|hotfix|docs|style|refactor|perf|test|build|ci|chore|config|revert)(\([^)]+\))?: .{1,72}$' \
  || { echo "expected ':shortcode: type(scope): subject'; types: feat feature fix bug hotfix docs style refactor perf test build ci chore config revert" >&2; exit 1; }
