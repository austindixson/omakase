# Omakase

Omarchy for people who will not leave Mac.

Hyprland muscle memory. Apple apps stay native. Taste and coherence are the
product — not a better tiler than AeroSpace, not an AI OS, not a Hyprland port.

This repo is the **FM-OMAKASE-1** Super map: section A (Navigate) is live in
AeroSpace; Raycast / agents / themes stay stubbed. Full install automation and
theme packs are out of scope here.

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

AeroSpace does not need SIP off. yabai often does. Omakase will not ask you to
turn SIP off, and will not ship a SIP-off path as the default install.

Confirm SIP is on before you start:

```bash
csrutil status
# expected: System Integrity Protection status: enabled.
```

## Cold-Mac install (v0 target: ≤10 minutes)

Scaffold only. There is no installer script yet. Copy stubs by hand.

### 0. Prerequisites

- A Mac you will keep as a Mac (Apple Silicon or Intel).
- SIP on (`csrutil status`).
- About ten minutes, including Accessibility prompts.

### 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the brew “Next steps” it prints (usually adding `brew` to `PATH`).

### 2. Engine, bar, launcher

```bash
brew install --cask nikitabobko/tap/aerospace
brew install FelixKratz/formulae/sketchybar
brew install --cask raycast
```

Grant Accessibility to AeroSpace when macOS asks. SketchyBar needs Screen
Recording if you later add a notch/background widget; skip that for the stub.

### 3. Drop in the configs

From a clone of this repo:

```bash
mkdir -p ~/.config/aerospace ~/.config/sketchybar

# Super map (section A Navigate binds are live)
cp config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml

# Bar placeholder — three themes will paint this later
cp config/sketchybar/sketchybarrc ~/.config/sketchybar/sketchybarrc
mkdir -p ~/.config/sketchybar/plugins
cp config/sketchybar/plugins/clock.sh ~/.config/sketchybar/plugins/clock.sh

# Raycast Super+Space + daily app launches: see config/raycast/
# Agents Super binds: see config/agents/
```

Reload AeroSpace after every copy (menu extra → Reload config, or
`aerospace reload-config` once the app is running). Section A chords are live
in this file; a stale process will keep the previous map. Start SketchyBar with
`brew services start sketchybar` when you want the bar process up; the stub
draws almost nothing.

### 4. Raycast owns Super+Space

In Raycast: set the hotkey to **Command+Space** and disable Spotlight’s
Command+Space in System Settings → Keyboard → Keyboard Shortcuts → Spotlight.
Daily app launches (terminal, browser, files, editor) live in
[`config/raycast/`](config/raycast/).

### 5. Smoke the v0 path

1. Super section A binds respond (workspace jump, focus, move, float / fullscreen, close).
2. Open Final Cut Pro (or Photos / QuickTime). It still opens. Native.
3. Hit the agent Super bind placeholder (`Super+Shift+Ctrl+A`) once agents
   are wired. Until then, the chord is documented, not live.

## Repo layout

```
config/aerospace/   Super-key map (section A Navigate live; B/C not bound here)
config/sketchybar/  Bar stub — themes will paint bar / borders / terminal
config/raycast/     Super+Space + daily app-launch preset stub
config/agents/      Super binds for local coding agents
docs/bind-parity.md Daily bind checklist (Omarchy A / B / C)
```

Nothing else is in scope for this scaffold. No extra apps, no theme packs,
no install automation.

## Bind parity

v0 target: **≥80% of the Omarchy daily set** (sections A / B / C).

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
