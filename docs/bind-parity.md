# Bind parity — Omarchy daily set

v0 target: **≥80% of the daily set implemented**.

Section A (Navigate) daily binds are **live** in AeroSpace, except
`Super+Tab` / `Super+Shift+Tab` (deferred — see below). Theme pick
(`Super+Ctrl+Shift+Space`) is live. Section B daily launches are the
first-party Raycast preset in `config/raycast/`. Agent rows in C stay stubbed.

Status values:

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
| A — Navigate | 14 | 0 | 14 | 10 |
| B — Launch | 8 | 0 | 8 | — |
| C — Agents & system | 4 | 3 | 1 | 3 |
| **Daily total** | **26** | **3** | **23** | — |
| **v0 implemented** | | | **23 / 26 (88%)** | need ≥21 / 26 |

Where a Mac bind lives: `config/aerospace/aerospace.toml` unless noted.
Section B lives in `config/raycast/`.

Legend in the Super map:

- `[mac-mapped]` — intended for v0 on AeroSpace / Raycast / agents
- `[deferred]` — Hyprland-only, Super clipboard, or nested app chords

---

## A — Navigate

Omarchy “Navigating” daily subset. Workspaces, focus, move, resize,
float / fullscreen, scratchpad, close.

| Omarchy | Action | Status | Mac note |
| --- | --- | --- | --- |
| `Super+1/2/3/4` | Jump to workspace | implemented | `cmd-1` … `cmd-4` → `workspace N` |
| `Super+Ctrl+Tab` | Former workspace | implemented | `cmd-ctrl-tab` → `workspace-back-and-forth`. Preferred over stealing the app switcher. |
| `Super+Shift+1/2/3/4` | Move window to workspace | implemented | `move-node-to-workspace --focus-follows-window N` |
| `Super+Shift+Alt+1/2/3/4` | Move window, do not follow | implemented | Supported. `move-node-to-workspace N` (AeroSpace default is no-follow; follow is the `--focus-follows-window` flag) |
| `Super+Arrow` | Focus in direction | implemented | `focus left/down/up/right` |
| `Super+Shift+Arrow` | Swap / move in direction | implemented | AeroSpace `move` |
| `Super+Minus` / `Super+Equal` | Resize horizontal | implemented | `resize smart ±50` |
| `Super+Shift+Minus` / `Equal` | Resize vertical | implemented | `resize smart-opposite ±50` |
| `Super+T` | Toggle tile / float | implemented | `layout floating tiling` |
| `Super+F` | Fullscreen | implemented | Collides with Mac Find — Super map wins |
| `Super+S` / `Super+Grave` | Toggle scratchpad | implemented | Grave only: `workspace --auto-back-and-forth scratch`. `cmd-s` is Save — not bound. Steals macOS cycle-windows-of-this-app. |
| `Super+Alt+S` | Move window to scratchpad | implemented | `move-node-to-workspace scratch` (no follow) |
| `Super+W` | Close window | implemented | AeroSpace `close`; not app Quit |
| `Super+Shift+Alt+Arrow` | Move workspace to monitor | implemented | `move-workspace-to-monitor --wrap-around <dir>` |

### A — deferred (not in the 80%)

| Omarchy | Why deferred |
| --- | --- |
| `Super+Tab` | Next workspace. `cmd-tab` is the macOS app switcher — do not steal it. Sequential walk can land later on a non-colliding chord (e.g. `cmd-ctrl-left` / `cmd-ctrl-right`). Former workspace is `Super+Ctrl+Tab`. |
| `Super+Shift+Tab` | Previous workspace. Same collision as `cmd-shift-tab` (app switcher reverse). |
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
`Super+Space` and app launches. Contract + checklist: `config/raycast/`.

| Omarchy | Action | Status | Mac note |
| --- | --- | --- | --- |
| `Super+Space` | Launcher | implemented | Raycast. Disable Spotlight on the same chord. Contract: `config/raycast/hotkeys.toml`. |
| `Super+Return` | Terminal | implemented | Ghostty (themes paint it). Terminal.app if Ghostty is absent. |
| `Super+Shift+Return` | Browser | implemented | Default browser. Safari on a stock Mac. |
| `Super+Shift+F` | Files | implemented | Finder |
| `Super+Shift+N` | Editor | implemented | TextEdit default. Override to Cursor / VS Code / Zed / Nova. |
| `Super+Shift+M` | Music | implemented | Music.app (native) |
| `Super+Shift+/` | Passwords | implemented | 1Password if installed; skip if not. No Store extension. |
| `Super+Escape` | System menu | implemented | No first-party power-menu UI. Built-in System Actions: Super+Space, then `lock` / `sleep` / `restart`. Optional: bind Super+Escape → Lock Screen. |

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
| `Super+Ctrl+Shift+Space` | Pick one of the three themes | implemented | AeroSpace `exec-and-forget` → `omakase-theme cycle`. Kyoto → Mocha → Ume. Paints SketchyBar, JankyBorders, Ghostty. |

### C — deferred (not in the 80%)

| Omarchy | Why deferred |
| --- | --- |
| `Super+C` / `X` / `V` | Super clipboard. Command clipboard stays native. |
| `Super+Ctrl+V` | Clipboard manager. Not a v0 daily bind. |
| Nested app chords | Tmux, Neovim, Ghostty, Compose. Apps keep their own maps. |

---

## How we count 80%

```
implemented daily rows / 26  ≥  0.80
```

The daily denominator dropped from 28 to 26 when `Super+Tab` / `Super+Shift+Tab`
moved to deferred (macOS app switcher stays native).

A row moves from `stubbed` to `implemented` when a cold-Mac install makes
that chord do the documented thing without hand-editing beyond the install
path in the README.

Deferred rows never enter the denominator.
