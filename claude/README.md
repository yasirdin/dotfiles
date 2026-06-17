# Claude Code config

## statusline.sh

Custom Claude Code status line. Reads the session JSON on stdin and prints:

```
Opus high · main* · ctx 42% · 5h 23% 7d 41% · $0.34 +156/-23
```

- **model + effort** — model name and reasoning effort (effort hidden if unsupported)
- **git branch + dirty** — branch name, yellow with `*` when there are uncommitted changes
- **context window %** — green <70, yellow 70–89, red 90+
- **usage limits** — 5h and 7d rolling-window usage (Pro/Max only, after first response)
- **cost + lines** — session cost estimate and lines added/removed

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
