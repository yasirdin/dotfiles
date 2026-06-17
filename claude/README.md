# Claude Code config

## statusline.sh

Custom Claude Code status line. Reads the session JSON on stdin and prints:

```
Opus high · main* · +156/-23 · ctx 42% · 5h 23% 7d 41% · $0.34
```

- **model + effort** — model name and reasoning effort (effort hidden if unsupported)
- **git branch + dirty** — branch name, yellow with `*` when there are uncommitted changes
- **diff stat** — lines added/removed vs the default branch (committed branch
  changes + uncommitted edits), like an MR diff. Falls back to uncommitted-only
  when the default branch can't be resolved.
- **context window %** — green <70, yellow 70–89, red 90+
- **usage limits** — 5h and 7d rolling-window usage (Pro/Max only, after first response)
- **cost** — session cost estimate

Requires `jq`. Colors target a Solarized theme; truecolor (`COLORTERM=truecolor`).

### Install

`make symlink` links this script to `~/.claude/statusline.sh`. To activate it,
add the following to `~/.claude/settings.json` (that file is not tracked here
because it holds machine/account-specific hooks and plugins):

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh",
  "padding": 0,
  "refreshInterval": 5
}
```
