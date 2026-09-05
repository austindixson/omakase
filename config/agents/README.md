# Agent Super binds

Local coding agents only. Omakase is not an AI OS.

These Super chords sit next to the AeroSpace map. They do not live in
a launcher store and they do not require a cloud agent host.

Status: **implemented**. Two small scripts, no launchd, no installer.

| Super chord | Script | Action |
| --- | --- | --- |
| `Super+Shift+Ctrl+A` | `omakase-agent pick` | Menu of agents already on this Mac |
| `Super+Ctrl+Return` | `omakase-agent primary` | Focus or launch the default local agent |
| `Super+Ctrl+L` | `omakase-lock` | Lock the screen |

Theme pick (`Super+Ctrl+Shift+Space`) is the theme switcher, not an agent.

## Daily chords (section C)

| Super chord | Action | Target |
| --- | --- | --- |
| `Super+Shift+Ctrl+A` | Pick a local agent | osascript list of what is installed or configured |
| `Super+Ctrl+Return` | Primary agent | Focus or launch your default local agent |
| `Super+Ctrl+L` | Lock | Control+Command+Q via System Events; `pmset` fallback |

Omarchy analogue: `Super+Shift+Ctrl+A` is “Pick an AI agent”;
`Super+Ctrl+Return` is Herdr (agent manager). Same muscle memory, local only.
Omakase does not ship Herdr and does not auto-install an agent.

## What is detected (never installed)

Built-in catalog, first match is the default primary:

1. **Cursor** — `Cursor.app` in `/Applications` or `~/Applications`
2. **Cursor Agent CLI** — `cursor-agent` on `PATH`, or `~/.local/bin/cursor-agent`, or `~/.local/bin/agent` when `~/.local/share/cursor-agent` exists
3. **aider** / **claude** / **codex** / **copilot** — the command is already on `PATH`

GUI rows use `open -a` (focus if running, launch if not). CLI rows open in
Ghostty (`-e`) when that binary is here, otherwise Terminal.app.

A stock Mac with no agents still gets a live chord: a dialog that says
nothing local was found. Omakase will not download one.

## Captain override

Copy [`agents.conf`](agents.conf) to `~/.config/omakase/agents.conf`.

```
primary=cursor-cli
cwd=~/src
extra=work-aider|Aider Work|cli|aider
```

`primary=` must be a detected id or an `extra=` id. `cwd=` is for CLI
launches only. `extra=` is `id|label|kind|target` with kind `app` or `cli`.

Cursor CLI notes (do not auto-install):

- The current binary name is often `agent`; older trees still use `cursor-agent`.
- We only treat a bare `agent` as Cursor when the Cursor install tree is present, so an unrelated `agent` on `PATH` is not stolen.
- Point `primary=` at `cursor-cli`, or add an `extra=` row with the full path, if you want the terminal agent instead of `Cursor.app`.

## What not to bind

- Super clipboard (`Super+C/X/V`) — deferred; Command clipboard stays native
- Nested in-app agent chords — the agent’s own keymap stays the agent’s
- Marketplace / “AI OS” launchers
- Super+Space — Omakase launcher (section B)

## Install

Same copy path as the theme switcher (`~/.config/omakase/bin/`):

```bash
cp bin/omakase-agent ~/.config/omakase/bin/omakase-agent
cp bin/omakase-lock ~/.config/omakase/bin/omakase-lock
```

AeroSpace already points Super+Shift+Ctrl+A / Super+Ctrl+Return /
Super+Ctrl+L at those paths (`/bin/bash -lc` so `$HOME` expands). Reload
the Super map after the copy.
