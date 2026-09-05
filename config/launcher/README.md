# Omakase launcher — section B

Owned, local, free. Super+Space is this launcher. There is no marketplace
and no paid service.

The CLI is [`bin/omakase-launch`](../../bin/omakase-launch). The panel is
the small SwiftUI app in [`src/launcher/`](../../src/launcher/). Daily
chords live in the AeroSpace Super map, not in a third-party hotkey file.

## Super+Space (the bind)

Omarchy uses Super+Space. Omakase does the same: AeroSpace binds
`cmd-space` to `omakase-launch` via `exec-and-forget`.

### Required: disable Spotlight’s ⌘Space

This is a cold-Mac step, not an optional fallback. Spotlight and
AeroSpace cannot share ⌘Space. Leave Spotlight on and Super+Space opens
Spotlight.

**System Settings → Keyboard → Keyboard Shortcuts → Spotlight → uncheck
Show Spotlight search.**

Do that before the first Super+Space. AeroSpace still needs
Accessibility. Unchecking Spotlight is what makes `cmd-space` →
`omakase-launch` win reliably.

### How to reclaim Spotlight

1. Turn **Show Spotlight search** back on.
2. Remove the `cmd-space` line from `~/.config/aerospace/aerospace.toml`
   and run `aerospace reload-config` (or quit AeroSpace).

`Super+Ctrl+Shift+Space` (theme cycle) is a different chord. It stays.

## Daily launches

Same muscle memory as Omarchy. AeroSpace runs `omakase-launch <verb>`.

| Super chord | Verb | Opens |
| --- | --- | --- |
| `Super+Space` | *(panel)* | App / file / command pick |
| `Super+Return` | `terminal` | Ghostty, else Terminal.app |
| `Super+Shift+Return` | `browser` | Safari, or `browser=` in `launch.conf` |
| `Super+Shift+F` | `files` | Finder |
| `Super+Shift+N` | `editor` | TextEdit, or `editor=` in `launch.conf` |
| `Super+Shift+M` | `music` | Music.app |
| `Super+Shift+/` | `passwords` | 1Password if installed; skip if not |
| `Super+Escape` | `system` | Lock / Sleep / Restart |

Type `lock`, `sleep`, or `restart` in the panel. Super+Escape is the
three-item system list. Super+Ctrl+L (section C) still locks directly.

## Panel

The intended UI is the SwiftUI panel. It reads Kyoto / Mocha / Ume from
`~/.config/omakase/current/theme.sh` — the same palette as workspace
pills, borders, and Ghostty.

```bash
# one-time, after Xcode Command Line Tools are present
swift build -c release --package-path src/launcher
mkdir -p ~/.config/omakase/libexec
cp src/launcher/.build/release/OmakaseLauncher ~/.config/omakase/libexec/
```

If that binary is missing, Super+Space falls back to a local osascript
prompt: type a name, or pick from the daily list. Direct Super chords
still work. No extra app is downloaded.

Super+Space toggles the Swift panel (second press dismisses). Escape
closes it.

## What not to add

- A marketplace, store, or paid launcher
- Omarchy webapp chords (HEY, Signal, YouTube, Maps)
- A SIP-off path
- Leaving Spotlight on ⌘Space and calling Super+Space “contested”
