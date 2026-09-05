# Bind parity — Omarchy daily set

v0 target: **≥80% of the daily set implemented**.

This scaffold **stubs** the map. Status values:

| Status | Meaning |
| --- | --- |
| `stubbed` | Documented and commented in the Super map. Not live yet. |
| `implemented` | Live in AeroSpace, Raycast, or the agent stub. |
| `deferred` | Out of the v0 daily set. Not counted in the 80%. |

**Daily set** = sections A + B + C below. Count a row once even when the
Omarchy chord has several keys (`Super+1/2/3/4` is one row).

Source: [Omarchy hotkeys](https://omarchy.org/manual/hotkeys/) — Navigating,
Launching apps, and the agent / lock / theme chords we treat as daily.

| | Daily rows | Stubbed | Implemented | Deferred (not in %) |
| --- | ---: | ---: | ---: | ---: |
| A — Navigate | 16 | 16 | 0 | 8 |
| B — Launch | 8 | 8 | 0 | — |
| C — Agents & system | 4 | 4 | 0 | 3 |
| **Daily total** | **28** | **28** | **0** | — |
| **v0 implemented** | | | **0 / 28 (0%)** | need ≥23 / 28 |

Where a Mac bind lives: `config/aerospace/aerospace.toml` unless noted.

Legend in the Super map:

- `[mac-mapped]` — intended for v0 on AeroSpace / Raycast / agents
- `[deferred]` — Hyprland-only, Super clipboard, or nested app chords

---

## A — Navigate

Omarchy “Navigating” daily subset. Workspaces, focus, move, resize,
float / fullscreen, scratchpad, close.

| Omarchy | Action | Status | Mac note |
| --- | --- | --- | --- |
| `Super+1/2/3/4` | Jump to workspace | stubbed | `cmd-1` … `cmd-4` |
| `Super+Tab` | Next workspace | stubbed | `cmd-tab` is app-switcher — see map comment |
| `Super+Shift+Tab` | Previous workspace | stubbed | |
| `Super+Ctrl+Tab` | Former workspace | stubbed | `workspace-back-and-forth` |
| `Super+Shift+1/2/3/4` | Move window to workspace | stubbed | |
| `Super+Shift+Alt+1/2/3/4` | Move window, do not follow | stubbed | `--fail-if-noop` / no auto-follow |
| `Super+Arrow` | Focus in direction | stubbed | |
| `Super+Shift+Arrow` | Swap / move in direction | stubbed | AeroSpace `move` |
| `Super+Minus` / `Super+Equal` | Resize horizontal | stubbed | `resize smart` |
| `Super+Shift+Minus` / `Equal` | Resize vertical | stubbed | |
| `Super+T` | Toggle tile / float | stubbed | `layout floating tiling` |
| `Super+F` | Fullscreen | stubbed | Collides with Mac Find — Super map wins |
| `Super+S` / `Super+Grave` | Toggle scratchpad | stubbed | Prefer Grave; `cmd-s` is Save |
| `Super+Alt+S` | Move window to scratchpad | stubbed | Dedicated `scratch` workspace |
| `Super+W` | Close window | stubbed | WM close; in-app `cmd-w` stays native |
| `Super+Shift+Alt+Arrow` | Move workspace to monitor | stubbed | |

### A — deferred (not in the 80%)

| Omarchy | Why deferred |
| --- | --- |
| `Super+L` | Hyprland dwindle ↔ scrolling. AeroSpace has tiles / accordion, not this pair. |
| `Super+P` | Dwindle pseudo. Hyprland-only. |
| `Super+J` | Toggle split. Hyprland-only. |
| `Super+O` | Sticky floating pop-out. No AeroSpace equivalent in v0. |
| `Super+G` / group chords | Hyprland window groups. Nested tab groups stay deferred. |
| `Super+Alt+F` / `Super+Ctrl+F` | Full-width / tiled-fullscreen Hyprland modes. |
| Super + mouse drag / resize | Nice later. Not a daily keyboard bind. |
| Super + scroll workspaces | Mouse. Not daily keyboard. |

---

## B — Launch

Omarchy “Launching apps” daily subset plus the launcher. Raycast owns
`Super+Space` and app launches; see `config/raycast/`.

| Omarchy | Action | Status | Mac note |
| --- | --- | --- | --- |
| `Super+Space` | Launcher | stubbed | Raycast. Disable Spotlight on the same chord. |
| `Super+Return` | Terminal | stubbed | Terminal.app or Ghostty — your call |
| `Super+Shift+Return` | Browser | stubbed | Safari or your default |
| `Super+Shift+F` | Files | stubbed | Finder |
| `Super+Shift+N` | Editor | stubbed | Your local editor |
| `Super+Shift+M` | Music | stubbed | Music.app (native) |
| `Super+Shift+/` | Passwords | stubbed | 1Password if installed |
| `Super+Escape` | System menu | stubbed | Raycast root / power commands |

Omarchy webapp chords (HEY, Signal, YouTube, Maps, …) are **not** in the
daily set. Omakase does not ship a Linux webapp farm.

---

## C — Agents & system

Locked Super binds for local coding agents, plus the two daily system
chords that keep the desktop coherent.

| Omarchy | Action | Status | Mac note |
| --- | --- | --- | --- |
| `Super+Shift+Ctrl+A` | Pick a local agent | stubbed | `config/agents/` |
| `Super+Ctrl+Return` | Primary agent / agent manager | stubbed | Herdr analogue — local only |
| `Super+Ctrl+L` | Lock | stubbed | `pmset` / lock screen |
| `Super+Ctrl+Shift+Space` | Pick one of the three themes | stubbed | Paints bar, borders, terminal |

### C — deferred (not in the 80%)

| Omarchy | Why deferred |
| --- | --- |
| `Super+C` / `X` / `V` | Super clipboard. Command clipboard stays native. |
| `Super+Ctrl+V` | Clipboard manager. Not a v0 daily bind. |
| Nested app chords | Tmux, Neovim, Ghostty, Compose. Apps keep their own maps. |

---

## How we count 80%

```
implemented daily rows / 28  ≥  0.80
```

A row moves from `stubbed` to `implemented` when a cold-Mac install makes
that chord do the documented thing without hand-editing beyond the install
path in the README.

Deferred rows never enter the denominator.
