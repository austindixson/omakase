# Agent Super binds

Local coding agents only. Omakase is not an AI OS.

These Super chords sit next to the AeroSpace map. They do not live in
Raycast marketplace extensions and they do not require a cloud agent host.

Status: **stubbed**. No scripts, no launchd, no installer.

## Daily chords (section C)

| Super chord | Action | Intended target |
| --- | --- | --- |
| `Super+Shift+Ctrl+A` | Pick a local agent | Menu / switcher over agents you already run |
| `Super+Ctrl+Return` | Primary agent | Focus or launch your default local agent |

Omarchy analogue: `Super+Shift+Ctrl+A` is “Pick an AI agent”;
`Super+Ctrl+Return` is Herdr (agent manager). Same muscle memory, local only.

## What to bind later

Name the processes you actually use. Examples, not a required list:

- A local Cursor / Copilot CLI session in a terminal
- A local aider / claude-code / codex process you already installed
- Anything that talks to a model on this machine

Do not ship a default cloud vendor. Do not auto-install an agent.

## What not to bind

- Super clipboard (`Super+C/X/V`) — deferred; Command clipboard stays native
- Nested in-app agent chords — the agent’s own keymap stays the agent’s
- Marketplace / “AI OS” launchers

Implementation belongs in a later change. Until then, keep the chords
documented here and unclaimed in `config/aerospace/aerospace.toml`.
