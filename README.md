# Omakase

Omarchy for people who will not leave Mac.

Hyprland muscle memory. Apple apps stay native. Taste and coherence are the
product — not a better tiler than AeroSpace, not an AI OS, not a Hyprland port.

This repo is the **FM-OMAKASE-1** Super map: section A (Navigate) is live in
AeroSpace; three themes paint SketchyBar, JankyBorders, and Ghostty from one
switch; Raycast section B is a first-party preset; section C agent Super
binds and lock are live. Full install automation is still out of scope.

## What this is

A locked macOS desktop that feels like Omarchy without leaving Apple’s apps.

- Super (Command) is the window-manager key, same muscle memory as Hyprland.
- Final Cut, Logic, Photos, and the rest keep opening as normal Mac apps.
- One launcher, one bar, three themes, one Super map.

## What this is not

- Not a faster AeroSpace. AeroSpace is the engine; Omakase is the taste.
- Not an AI operating system. Local coding agents get Super binds. That is it.
- Not a Hyprland port. No compositor clone. No Linux userspace on the Mac.

## Locked decisions

| Piece | Choice |
| --- | --- |
| Engine | [AeroSpace](https://github.com/nikitabobko/AeroSpace) with **SIP on** |
| Launcher | Raycast, via a first-party preset (not the marketplace) |
| Bar | [SketchyBar](https://github.com/FelixKratz/SketchyBar) |
| Borders | [JankyBorders](https://github.com/FelixKratz/JankyBorders) (SIP on; AeroSpace has no border color) |
| Terminal | [Ghostty](https://ghostty.org) — primary. Terminal.app is not painted. |
| Themes | Three. Each paints bar, borders, and terminal. |
| Modifier | Super = Command. Omarchy daily binds, Mac-mapped. |
| Agents | Super binds for local coding agents you already run |

## Non-goals

These are explicit. Do not “just add” them.

- **Replace the macOS window server.** AeroSpace tiles on top of it. Period.
- **yabai / SIP-off as the default.** SIP stays on. No scripting SIP disable.
- **Full Quickshell clone.** SketchyBar is the bar. No Linux shell rewrite.
- **Dual-boot / Asahi.** This is macOS. Stay on macOS.
- **Raycast marketplace day one.** The preset lives in this repo.

## SIP stays on

System Integrity Protection remains enabled. That is a product constraint, not
a footnote.

AeroSpace does not need SIP off. yabai often does. JankyBorders does not.
Omakase will not ask you to turn SIP off, and will not ship a SIP-off path as
the default install.

Confirm SIP is on before you start:

```bash
csrutil status
# expected: System Integrity Protection status: enabled.
```

## Three themes

One switch paints three surfaces: SketchyBar, JankyBorders, Ghostty. Palettes
live in `config/themes/<name>/theme.sh` (bar + borders) and `ghostty.conf`
(same hex). Default is **Kyoto**.

| Name | Look |
| --- | --- |
| **Kyoto** | Temple night. Warm sumi ink, aged paper, vermilion, gold leaf. |
| **Mocha** | Warm dusk latte. Mauve, peach, steel. Catppuccin-adjacent. |
| **Ume** | Plum dusk. Rose, pine, iris. Rose Pine-adjacent. |

```bash
omakase-theme              # cycle Kyoto → Mocha → Ume → Kyoto
omakase-theme kyoto        # set one
omakase-theme list
omakase-theme current
```

`Super+Ctrl+Shift+Space` runs `omakase-theme cycle` from AeroSpace. The bar
shows the theme name on the right so the chord is visible.

Ghostty is the primary terminal. The switcher points
`~/.config/ghostty/omakase-theme` at the active `ghostty.conf` and touches
Ghostty’s main config so it reloads. Open a new Ghostty window if an old one
keeps the previous palette. Terminal.app is not in this slice.

**Borders:** AeroSpace has no window-border color. Omakase uses
[JankyBorders](https://github.com/FelixKratz/JankyBorders) (`brew install
FelixKratz/formulae/borders`), the usual SIP-on pair with SketchyBar +
AeroSpace. See `config/borders/bordersrc`.

## Cold-Mac install (v0 target: ≤10 minutes)

No installer script. Copy by hand, then run the theme switcher once.

### 0. Prerequisites

- A Mac you will keep as a Mac (Apple Silicon or Intel).
- SIP on (`csrutil status`).
- About ten minutes, including Accessibility prompts.

### 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the brew “Next steps” it prints (usually adding `brew` to `PATH`).

### 2. Engine, bar, borders, launcher, terminal

```bash
brew install --cask nikitabobko/tap/aerospace
brew install FelixKratz/formulae/sketchybar
brew install FelixKratz/formulae/borders
brew install --cask raycast
brew install --cask ghostty
```

Grant Accessibility to AeroSpace when macOS asks. SketchyBar needs Screen
Recording if you later add a notch/background widget; skip that for v0.

### 3. Drop in the configs

From a clone of this repo:

```bash
mkdir -p ~/.config/aerospace ~/.config/sketchybar/plugins \
         ~/.config/borders ~/.config/ghostty \
         ~/.config/omakase/themes ~/.config/omakase/bin

# Super map (section A Navigate + section C agents / lock / theme cycle)
cp config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml

# Bar (reads ~/.config/omakase/current)
cp config/sketchybar/sketchybarrc ~/.config/sketchybar/sketchybarrc
cp config/sketchybar/colors.sh ~/.config/sketchybar/colors.sh
cp config/sketchybar/plugins/* ~/.config/sketchybar/plugins/

# Borders (JankyBorders)
cp config/borders/bordersrc ~/.config/borders/bordersrc

# Ghostty — primary terminal. Include is ?omakase-theme (set by the switcher).
cp config/ghostty/config ~/.config/ghostty/config

# Three themes + switcher + local agent Super binds
cp -R config/themes/* ~/.config/omakase/themes/
cp bin/omakase-theme ~/.config/omakase/bin/omakase-theme
cp bin/omakase-agent ~/.config/omakase/bin/omakase-agent
cp bin/omakase-lock ~/.config/omakase/bin/omakase-lock

# Raycast Super+Space + daily app launches: config/raycast/ (checklist)
# Agent catalog + captain override: config/agents/
```

Paint Kyoto (creates `~/.config/omakase/current` and the Ghostty include):

```bash
~/.config/omakase/bin/omakase-theme kyoto
```

Reload AeroSpace after every copy (menu extra → Reload config, or
`aerospace reload-config` once the app is running). Section A chords,
section C agent / lock chords, and `Super+Ctrl+Shift+Space` are live in
this file; a stale process will keep the previous map. Start the bar and
borders if AeroSpace has not already:

```bash
brew services start sketchybar
brew services start borders
```

### 4. Raycast owns Super+Space (section B)

The first-party preset is [`config/raycast/`](config/raycast/). No marketplace.
No `.rayconfig` (encrypted, not durable). Finish this by hand:

1. Open Raycast → Settings → General → Raycast Hotkey → **Command+Space**.
2. System Settings → Keyboard → Keyboard Shortcuts → Spotlight → uncheck
   **Show Spotlight search** (Command+Space).
3. Settings → Shortcuts → **Applications** — assign the daily launches:

   | Super | Opens |
   | --- | --- |
   | `Super+Return` | Ghostty (or Terminal.app if Ghostty is missing) |
   | `Super+Shift+Return` | Default browser (Safari on a stock Mac) |
   | `Super+Shift+F` | Finder |
   | `Super+Shift+N` | TextEdit — change to your editor if you already have one |
   | `Super+Shift+M` | Music.app |
   | `Super+Shift+/` | 1Password if installed; skip if not |

4. Settings → Shortcuts → **System Actions** — aliases `lock`, `sleep`,
   `restart`. Super+Space, then type the name. Optional: bind Super+Escape
   to Lock Screen.

Full table and skip rules: [`config/raycast/README.md`](config/raycast/README.md).

### 5. Smoke the v0 path

1. Super section A binds respond (workspace jump, focus, move, float / fullscreen, close).
2. Open Final Cut Pro (or Photos / QuickTime). It still opens. Native.
3. `Super+Ctrl+Shift+Space` cycles Kyoto → Mocha → Ume. Bar, borders, and a
   new Ghostty window follow.
4. Super+Space opens Raycast (Spotlight does not). Super+Return opens Ghostty
   or Terminal. Super+Shift+F opens Finder.
5. `Super+Shift+Ctrl+A` lists local agents already on this Mac (Cursor,
   Cursor Agent CLI, aider / claude / codex / copilot, plus `extra=`).
   `Super+Ctrl+Return` focuses or launches the primary (Cursor if present).
   `Super+Ctrl+L` locks the screen. Nothing is auto-installed.

## Repo layout

```
bin/omakase-theme       Cycle or set Kyoto / Mocha / Ume
bin/omakase-agent       Pick / focus a local coding agent
bin/omakase-lock        Lock screen (Super+Ctrl+L)
config/aerospace/       Super-key map (A + C agents / lock / theme)
config/themes/          Shared palettes (theme.sh + ghostty.conf)
config/sketchybar/      Bar — reads the active theme
config/borders/         JankyBorders — same palette
config/ghostty/         Ghostty include for the active theme
config/raycast/         Super+Space + daily app-launch preset (section B)
config/agents/          Local agent catalog + captain override
docs/bind-parity.md     Daily bind checklist (Omarchy A / B / C)
```

No `.rayconfig` and no install automation. Raycast is the checklist in
`config/raycast/`.

## Bind parity

v0 target: **≥80% of the Omarchy daily set** (sections A / B / C).
Section A + B + C is **26 / 26 (100%)**. Agent rows detect what is
already local; they do not install a vendor.

The checklist is [`docs/bind-parity.md`](docs/bind-parity.md). Status is one of
`stubbed` / `implemented` / `deferred`.

Deferred on purpose (not counted against the 80%):

- `Super+Tab` / `Super+Shift+Tab` — keep the macOS app switcher; former workspace is `Super+Ctrl+Tab`
- Hyprland-only layouts (dwindle / scrolling, pseudo, group tabs)
- Super clipboard (`Super+C/X/V`) — Command clipboard stays native
- Nested in-app chords (tmux, Neovim, Ghostty, Compose)

## Proof video (v0)

Public proof that a cold Mac becomes Omakase. One take, no jump cuts that hide
time. The README plus this video are the v0 demo.

Must show, in order:

1. **Cold Mac** — SIP enabled, no prior AeroSpace / SketchyBar / Raycast setup
   (or a clearly wiped config).
2. **Install ≤10 minutes** — Homebrew, AeroSpace, SketchyBar, Raycast preset,
   Super map. Wall-clock visible.
3. **Super binds** — workspace jump, focus, move, float/fullscreen, close.
4. **Final Cut still opens** — launch Final Cut Pro (or another Apple pro app
   if FCP is not installed) and use it as a normal Mac app.
5. **Agent hotkey** — Super bind that focuses or launches a local coding agent.

Link the video from a future release note. This scaffold only defines the
criteria.

## License

[MIT](LICENSE).
