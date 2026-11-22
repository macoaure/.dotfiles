---
name: gitmoji-commits
description: Plans and makes git commits in the format ":shortcode: type(scope): subject" (gitmoji shortcode + semantic prefix). Use when the user asks to commit, split a diff into commits, or write a commit message, even for a bare "commit this".
---

# Gitmoji commits

Message format, first line:

    :shortcode: type(scope): subject

- `:shortcode:` is plain text (`:sparkles:`), never the emoji character, so history stays greppable.
- `type` is one of: feat feature fix bug hotfix docs style refactor perf test build ci chore config revert.
- `(scope)` is optional. `subject` is imperative, lowercase, no trailing period, at most 72 chars.
- After a blank line comes a long, contextual body, written from the actual diff and what you know of the task. Cover the problem or motivation, what changed and where, why this approach, and any trade-offs, side effects or follow-ups. Format it as one plain context sentence, then a `-` bullet list (one fact per bullet, wrapped near 72 columns), ending with a `- Trade-off:` or `- Note:` bullet when relevant. Never just restate the subject. Add a `BREAKING CHANGE:` footer for breaking changes.
- Example: `:sparkles: feat(auth): add OAuth login support`

## Workflow

1. **Survey**: run `git status`, `git diff` and `git diff --staged`. Respect already-staged files. Stop and warn, without committing, on conflict markers, secrets (`.env`, keys, tokens) or generated/binary files that don't belong. Nothing to commit: say so.
2. **Group by context, not by file**: a commit is one contextual unit of work (a feature with its tests and docs, or a set of config files changed for the same reason), usually 1-3 commits and often just one. Never make one commit per file. Merge anything that shares a purpose or the same session's goal, even across packages. Split only when changes are clearly unrelated in purpose, or when order matters (dependency bump before the code using it, pure rename before the edit after it). Use `git add -p` only when one file mixes unrelated purposes. Order dependencies first.
3. **Pick the gitmoji**: list them with `gitmoji -l`, or if that command is missing, `docker run --rm node:alpine npx -y gitmoji-cli -l` (needs Docker; the first run pulls the image). Each line is `emoji - :shortcode: - description`; pick the best fit and use only the `:shortcode:`.
4. **Validate each subject line** before committing: `sh ~/.claude/skills/gitmoji-commits/scripts/check-msg.sh "<subject line>"`. Exit 1 means the format is wrong and the error lists the allowed types, so fix and rerun.
5. **Confirm once**: show each commit as its files, subject line and full body, with no numbering, separated by `---` lines, and get one go-ahead.
6. **Commit in order**: stage exactly that commit's files, check `git status` shows only them, then `git commit -F - <<'EOF'` with the subject, a blank line and the multi-line body, using plain git (the gitmoji CLI is interactive, so use it only for the emoji list). Finish with `git log --oneline -n <count>`.

## Edge cases

- Not a git repo: offer `git init`. Mid-rebase or merge: check `git status` first.
- Entangled changes: one commit, using the more significant change's gitmoji.
