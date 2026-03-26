---
name: gitmoji-commits
description: Generate or suggest commit messages in gitmoji format (emoji + short description). Use when writing commits, amending messages, or when the user asks for gitmoji-style or emoji commits. Reference https://gitmoji.dev/
---

# Gitmoji commits

When writing or suggesting commit messages, use the **gitmoji** format: start the subject line with the appropriate emoji (or `:shortcode:`) followed by a short, imperative description.

## Format

```
<emoji> <subject>

[optional body]
```

- **Subject:** one line, imperative mood, ~50 chars. Start with the emoji (e.g. `✨ Add user login`).
- **Body (optional):** explain what and why, wrap at 72 chars.

Use the **emoji character** in the message (e.g. `✨`), not the `:shortcode:` in the final commit (shortcodes are for reference).

## Choosing the right gitmoji

1. Decide the **type of change** (feature, fix, docs, refactor, etc.).
2. Pick the matching emoji from the reference below (or [reference.md](reference.md) for the full list).
3. Write the subject in imperative: "Add X", "Fix Y", "Update Z".

## Quick reference (common)

| Emoji | Shortcode | Use for |
|-------|-----------|--------|
| ✨ | `:sparkles:` | New feature |
| 🐛 | `:bug:` | Bug fix |
| 📝 | `:memo:` | Documentation |
| 🚀 | `:rocket:` | Deploy |
| 🎨 | `:art:` | Structure/format (no code logic change) |
| ⚡️ | `:zap:` | Performance |
| 🔥 | `:fire:` | Remove code or files |
| 🚑️ | `:ambulance:` | Critical hotfix |
| ♻️ | `:recycle:` | Refactor |
| ✅ | `:white_check_mark:` | Add or update tests |
| 🔒️ | `:lock:` | Security/fix |
| 🚧 | `:construction:` | WIP |
| 💚 | `:green_heart:` | Fix CI |
| 🔧 | `:wrench:` | Config |
| ➕ | `:heavy_plus_sign:` | Add dependency |
| ➖ | `:heavy_minus_sign:` | Remove dependency |
| 🏗️ | `:building_construction:` | Architecture |
| 🚚 | `:truck:` | Move/rename files or routes |
| 💥 | `:boom:` | Breaking change |
| 📦️ | `:package:` | Compiled/output or package |
| 🩹 | `:adhesive_bandage:` | Simple non-critical fix |
| 🧪 | `:test_tube:` | Add failing test |
| 🩺 | `:stethoscope:` | Healthcheck |

For the **full list** (accessibility, i18n, database, etc.), see [reference.md](reference.md).

## Examples

- New feature: `✨ Add JWT authentication to API`
- Bug fix: `🐛 Fix date timezone in report export`
- Docs: `📝 Document REST and shared Swagger convention`
- Refactor: `♻️ Extract validation into shared module`
- Remove: `🔥 Remove deprecated PRE v1 endpoints`
- Security: `🔒️ Sanitize user input in shred request`

When the user asks to "commit with gitmoji" or "use gitmoji", suggest a message following this format and the table above.
