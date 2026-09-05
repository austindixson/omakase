# Raycast preset — section B

Omakase launcher. Raycast is locked. The marketplace is a non-goal for day one.
This folder is the first-party preset, not an extension listing.

`Super+Space` (Command+Space) is Raycast. Disable Spotlight on that chord.

The contract is [`hotkeys.toml`](hotkeys.toml). That file is the preset.

## Why there is no `.rayconfig`

Raycast’s **Export Settings & Data** writes an encrypted `.rayconfig` (passphrase,
clipboard / AI / Store extensions bundled in). The blob has already changed
shape (v1 AES-CBC vs v2 AES-GCM). We will not ship a reverse-engineered copy.

**Import Quicklinks** is the only official unencrypted JSON import. It does not
carry hotkeys, and Application hotkeys are the right first-party way to launch
apps. So this preset is the TOML contract plus the checklist below.

A cold Mac finishes this in a few minutes after `brew install --cask raycast`.

## Cold-Mac checklist

### 1. Raycast owns Super+Space

1. Open Raycast.
2. Settings → General → Raycast Hotkey → **Command+Space**.
3. System Settings → Keyboard → Keyboard Shortcuts → Spotlight → uncheck
   **Show Spotlight search** (Command+Space).

Spotlight and Raycast cannot share that chord.

### 2. Daily app launches (Applications)

Settings → Shortcuts. Filter **Applications**. Click the hotkey field, press
the chord.

| Super chord | Hotkey | Assign to | If missing |
| --- | --- | --- | --- |
| `Super+Return` | Command+Return | **Ghostty** | **Terminal** (themes do not paint Terminal.app) |
| `Super+Shift+Return` | Command+Shift+Return | Your **default browser** | Safari on a stock Mac |
| `Super+Shift+F` | Command+Shift+F | **Finder** | — |
| `Super+Shift+N` | Command+Shift+N | **TextEdit** | Change to Cursor / VS Code / Zed / Nova if that is your editor |
| `Super+Shift+M` | Command+Shift+M | **Music** | — |
| `Super+Shift+/` | Command+Shift+/ | **1Password** | Skip this row. Do not add a Store password extension. |

Older Raycast: Settings → Extensions → Applications, same hotkey column.

### 3. System commands (Super+Escape)

Settings → Shortcuts. Filter **System Actions** (built-in, already installed).

| Command | What to set |
| --- | --- |
| Lock Screen | Alias `lock`. Optional: hotkey **Command+Escape** (one-shot) |
| Sleep | Alias `sleep` |
| Restart | Alias `restart` |

Raycast has no first-party power-menu window. Omarchy `Super+Escape` is
**Super+Space**, then type `lock` / `sleep` / `restart`, Enter.

`Super+Ctrl+L` (section C lock) is AeroSpace → `omakase-lock`. Do not bind it here.

### 4. Smoke

1. Command+Space opens Raycast. Spotlight does not.
2. Super+Return focuses or launches Ghostty (or Terminal).
3. Super+Shift+F opens Finder.
4. Super+Space, type `lock` — Lock Screen is the top hit. Do not confirm it
   unless you mean to lock.

## What not to add

- Store / marketplace extensions
- Omarchy webapp chords (HEY, Signal, YouTube, Maps)
- A scripted importer, a `.rayconfig`, or a SIP-off path
