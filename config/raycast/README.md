# Raycast preset stub

Omakase launcher. Raycast is locked. The marketplace is a non-goal for day one.
This folder is the first-party preset, not an extension listing.

`Super+Space` (Command+Space) is Raycast. Disable Spotlight on that chord.

## Cold-Mac steps (manual)

1. `brew install --cask raycast`
2. Open Raycast → Settings → General → Raycast Hotkey → **Command+Space**
3. System Settings → Keyboard → Keyboard Shortcuts → Spotlight → uncheck
   **Show Spotlight search** (Command+Space)
4. Map the daily app launches below (Settings → Extensions → Hotkeys)

There is no `.rayconfig` export in this scaffold. The table is the contract.

## Daily launches (section B)

| Super chord | Opens | Notes |
| --- | --- | --- |
| `Super+Space` | Raycast | Replaces Spotlight |
| `Super+Return` | Terminal | Terminal.app or Ghostty |
| `Super+Shift+Return` | Browser | Default browser |
| `Super+Shift+F` | Files | Finder |
| `Super+Shift+N` | Editor | Whatever you already use locally |
| `Super+Shift+M` | Music | Music.app — native |
| `Super+Shift+/` | Passwords | 1Password if installed; skip if not |
| `Super+Escape` | System commands | Raycast root: lock / sleep / restart |

Status of every row: **stubbed**. See `docs/bind-parity.md`.

Do not add Omarchy webapp chords (HEY, Signal, YouTube, Maps) here.
