# Omakase

Omarchy for people who will not leave Mac.

Hyprland muscle memory. Apple apps stay native. Taste and coherence are the
product — not a better tiler than AeroSpace, not an AI OS, not a Hyprland port.

This repo is the **FM-OMAKASE-1** Super map plus **FM-OMAKASE-2** live-try
fixes: section A (Navigate) is live in AeroSpace; three themes paint
workspace pills, JankyBorders, and Ghostty from one switch; section B is
the owned Omakase launcher; section C agent primary is **Option+Enter**.
The bar is workspace-only in the native menu bar. Cold-Mac install is
`./bin/install`.

## What this is

A locked macOS desktop that feels like Omarchy without leaving Apple’s apps.

- Super (Command) is the window-manager key, same muscle memory as Hyprland.
- Final Cut, Logic, Photos, and the rest keep opening as normal Mac apps.
- One launcher, workspace pills in the Mac menu bar, three themes, one Super map.

## What this is not

- Not a faster AeroSpace. AeroSpace is the engine; Omakase is the taste.
- Not an AI operating system. Local coding agents get Super binds. That is it.
- Not a Hyprland port. No compositor clone. No Linux userspace on the Mac.

## Locked decisions

| Piece | Choice |
| --- | --- |
| Engine | [AeroSpace](https://github.com/nikitabobko/AeroSpace) with **SIP on** |
| Launcher | Omakase launcher — local, owned, no store |
| Bar | [SketchyBar](https://github.com/FelixKratz/SketchyBar) workspace pills in the native menu bar. No clock / battery / wordmark / theme-name chrome. |
| Borders | [JankyBorders](https://github.com/FelixKratz/JankyBorders) (SIP on; AeroSpace has no border color) |
| Terminal | [Ghostty](https://ghostty.org) — primary. Terminal.app is not painted. |
| Themes | Three. Each paints workspace pills, borders, and terminal. |
| Modifier | Super = Command. Omarchy daily binds, Mac-mapped. |
| Agents | Super binds for local coding agents you already run |

## Non-goals

These are explicit. Do not “just add” them.

- **Replace the macOS window server.** AeroSpace tiles on top of it. Period.
- **yabai / SIP-off as the default.** SIP stays on. No scripting SIP disable.
- **Full Quickshell clone.** Workspace pills in the Mac menu bar. No Linux shell rewrite. No Omarchy-style status bar.
- **Dual-boot / Asahi.** This is macOS. Stay on macOS.
- **A third-party or paid launcher.** Super+Space is the launcher in this repo.

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

One switch paints three surfaces: workspace pills, JankyBorders, Ghostty.
Palettes live in `config/themes/<name>/theme.sh` (pills + borders) and
`ghostty.conf` (same hex). Default is **Kyoto**. The bar does not show
the theme name — pills change color; borders and Ghostty do the rest.

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

`Super+Ctrl+Shift+Space` runs `omakase-theme cycle` from AeroSpace. Pills,
borders, and a new Ghostty window follow. There is no theme-name widget.

Ghostty is the primary terminal. The switcher points
`~/.config/ghostty/omakase-theme` at the active `ghostty.conf` and touches
Ghostty’s main config so it reloads. Open a new Ghostty window if an old one
keeps the previous palette. Terminal.app is not in this slice.

**Borders:** AeroSpace has no window-border color. Omakase uses
[JankyBorders](https://github.com/FelixKratz/JankyBorders) (`brew install
FelixKratz/formulae/borders`), the usual SIP-on pair with SketchyBar +
AeroSpace. See `config/borders/bordersrc`.

## Cold-Mac install (v0 target: ≤10 minutes)

One shot from a clone of this repo:

```bash
./bin/install
```

The script confirms SIP is on (and exits if it is not — there is no
SIP-off path), requires Homebrew, installs AeroSpace, SketchyBar,
JankyBorders, and Ghostty, copies the Super map / workspace pills /
borders / Ghostty / themes / owned launcher, paints Kyoto, and starts
the stack where it can. Re-run is safe: product files overwrite;
`launch.conf` and `agents.conf` are left alone if you already have them.
Leftover `clock.sh` / `front_app.sh` from an older bar are deleted.

If Homebrew is missing, the script prints the official installer command
and stops. Install brew, add it to `PATH`, then re-run `./bin/install`.

`./bin/install --copy-only` refreshes configs and Kyoto without touching
packages. That is also the Linux-testable path.

### Captain next steps (the script prints these)

1. Grant Accessibility to AeroSpace when macOS asks.
2. Super+Space opens the Omakase launcher. Super+Return / Super+Shift+F
   are the first daily binds. Super+Ctrl+Shift+Space cycles themes.
   Option+Enter focuses or launches the primary agent.
3. Spotlight ⌘Space disable is **required**. System Settings → Keyboard
   → Keyboard Shortcuts → Spotlight → uncheck Show Spotlight search.
   Super+Space only wins after that. See
   [`config/launcher/README.md`](config/launcher/README.md).

SketchyBar is workspace pills on the native menu bar only — no Screen
Recording, no clock / wordmark / theme-name chrome. See
[`config/sketchybar/README.md`](config/sketchybar/README.md).

### Super+Space is the Omakase launcher (section B)

AeroSpace binds `cmd-space` to `omakase-launch`. That is the Omarchy
chord. It wins only after Spotlight’s ⌘Space is unchecked.

Daily launches are the same file:

| Super | Opens |
| --- | --- |
| `Super+Return` | Ghostty (or Terminal.app if Ghostty is missing) |
| `Super+Shift+Return` | Safari (or `browser=` in `~/.config/omakase/launch.conf`) |
| `Super+Shift+F` | Finder |
| `Super+Shift+N` | TextEdit — set `editor=` if you already have one |
| `Super+Shift+M` | Music.app |
| `Super+Shift+/` | 1Password if installed; skip if not |
| `Super+Escape` | Lock / Sleep / Restart |

Type `lock`, `sleep`, or `restart` in the panel. Optional: build the
SwiftUI panel (`swift build -c release --package-path src/launcher`) and
copy `OmakaseLauncher` to `~/.config/omakase/libexec/`. Without that
binary, Super+Space uses a local osascript prompt. Direct Super chords
still work.

Full table: [`config/launcher/README.md`](config/launcher/README.md).

### Smoke the v0 path

1. Super section A binds respond (workspace jump, focus, move, float / fullscreen, close). New windows tile; only Final Cut / Logic / Photos / QuickTime float.
2. Open Final Cut Pro (or Photos / QuickTime). It still opens. Native.
3. `Super+Ctrl+Shift+Space` cycles Kyoto → Mocha → Ume. Workspace pills,
   borders, and a new Ghostty window follow. No clock / wordmark / theme name.
4. Super+Space opens the Omakase launcher (not Spotlight). Super+Return
   opens Ghostty or Terminal. Super+Shift+F opens Finder.
5. `Super+Shift+Ctrl+A` lists local agents already on this Mac (Cursor,
   Cursor Agent CLI, aider / claude / codex / copilot, plus `extra=`).
   `Option+Enter` focuses or launches the primary (Cursor if present).
   `Super+Ctrl+L` locks the screen. Nothing is auto-installed.

### Manual path (fallback)

If you cannot run `./bin/install`, copy by hand.

#### 0. Prerequisites

- A Mac you will keep as a Mac (Apple Silicon or Intel).
- SIP on (`csrutil status`).
- About ten minutes, including Accessibility prompts.

#### 1. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the brew “Next steps” it prints (usually adding `brew` to `PATH`).

#### 2. Engine, workspace pills, borders, terminal

```bash
brew install --cask nikitabobko/tap/aerospace
brew install FelixKratz/formulae/sketchybar
brew install FelixKratz/formulae/borders
brew install --cask ghostty
```

Grant Accessibility to AeroSpace when macOS asks. SketchyBar is only
workspace pills on the native menu bar — no Screen Recording, no clock /
wordmark / theme-name chrome. See [`config/sketchybar/README.md`](config/sketchybar/README.md).

#### 3. Drop in the configs

From a clone of this repo:

```bash
mkdir -p ~/.config/aerospace ~/.config/sketchybar/plugins \
         ~/.config/borders ~/.config/ghostty \
         ~/.config/omakase/themes ~/.config/omakase/bin

# Super map (A Navigate + B launcher + C agents / lock / theme cycle)
cp config/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml

# Workspace pills only (reads ~/.config/omakase/current).
# Drop stale FM-OMAKASE-1 chrome if a previous copy left it.
rm -f ~/.config/sketchybar/plugins/clock.sh \
      ~/.config/sketchybar/plugins/front_app.sh
cp config/sketchybar/sketchybarrc ~/.config/sketchybar/sketchybarrc
cp config/sketchybar/colors.sh ~/.config/sketchybar/colors.sh
cp config/sketchybar/plugins/spaces.sh ~/.config/sketchybar/plugins/spaces.sh

# Borders (JankyBorders)
cp config/borders/bordersrc ~/.config/borders/bordersrc

# Ghostty — primary terminal. Include is ?omakase-theme (set by the switcher).
cp config/ghostty/config ~/.config/ghostty/config

# Three themes + switcher + launcher + local agent Super binds
cp -R config/themes/* ~/.config/omakase/themes/
cp bin/omakase-theme ~/.config/omakase/bin/omakase-theme
cp bin/omakase-launch ~/.config/omakase/bin/omakase-launch
cp bin/omakase-agent ~/.config/omakase/bin/omakase-agent
cp bin/omakase-lock ~/.config/omakase/bin/omakase-lock
cp config/launcher/launch.conf ~/.config/omakase/launch.conf

# Optional: build the SwiftUI panel (osascript fallback works without it)
# cp -R src/launcher ~/.config/omakase/src/launcher
# Agent catalog + captain override: config/agents/
```

Paint Kyoto (creates `~/.config/omakase/current` and the Ghostty include):

```bash
~/.config/omakase/bin/omakase-theme kyoto
```

Reload AeroSpace after every copy (menu extra → Reload config, or
`aerospace reload-config` once the app is running). Section A chords,
section C agent / lock chords, and `Super+Ctrl+Shift+Space` are live in
this file; a stale process will keep the previous map. Start the
workspace overlay and borders if AeroSpace has not already:

```bash
brew services start sketchybar
brew services start borders
```

#### 4. Disable Spotlight’s ⌘Space (required)

Super+Space is the Omakase launcher. Spotlight and AeroSpace cannot share
⌘Space. This is a required cold-Mac step, not a contested fallback.

**System Settings → Keyboard → Keyboard Shortcuts → Spotlight → uncheck
Show Spotlight search.**

Do this before the first Super+Space. To reclaim Spotlight later: turn
that checkbox back on, remove `cmd-space` from `aerospace.toml`, and
reload (or quit AeroSpace). Full contract:
[`config/launcher/README.md`](config/launcher/README.md).

## Repo layout

```
bin/install             Cold-Mac one-shot (SIP on, packages, configs, Kyoto)
bin/omakase-theme       Cycle or set Kyoto / Mocha / Ume
bin/omakase-agent       Pick / focus a local coding agent
bin/omakase-lock        Lock screen (Super+Ctrl+L)
bin/omakase-launch      Super+Space + daily app launches (section B)
bin/omakase-proof-demo  Non-interactive proof take (aerospace + product bins)
config/aerospace/       Super-key map (A + B launcher + C agents / lock / theme)
config/themes/          Shared palettes (theme.sh + ghostty.conf)
config/sketchybar/      Workspace pills only (what install copies)
config/borders/         JankyBorders — same palette
config/ghostty/         Ghostty include for the active theme
config/launcher/        Super+Space contract + launch.conf overrides
src/launcher/           SwiftUI panel (optional build; osascript fallback)
config/agents/          Local agent catalog + captain override
docs/bind-parity.md     Daily bind checklist (Omarchy A / B / C)
docs/tiling.md          SIP-on AeroSpace vs Hyprland (honest limits)
docs/proof-video.md     v0 shot list (post-#8 product)
docs/proof/             Release asset pointer (proof-v0 / omakase-v0.mp4)
```

The launcher is `bin/omakase-launch` plus, when you build it, the panel
in `src/launcher/`. `./bin/install` copies both and builds the panel
when `swift` is on `PATH`.

## Bind parity

v0 target: **≥80% of the Omarchy daily set** (sections A / B / C).
Section A + B + C is **26 / 26 (100%)**. Agent rows detect what is
already local; they do not install a vendor.

The checklist is [`docs/bind-parity.md`](docs/bind-parity.md). Status is one of
`stubbed` / `implemented` / `deferred`.

Deferred on purpose (not counted against the 80%):

- `Super+Tab` / `Super+Shift+Tab` — keep the macOS app switcher; former workspace is `Super+Ctrl+Tab`
- Hyprland-only layouts (dwindle / scrolling, pseudo, group tabs) — see [`docs/tiling.md`](docs/tiling.md)
- Super clipboard (`Super+C/X/V`) — Command clipboard stays native
- Nested in-app chords (tmux, Neovim, Ghostty, Compose)

## Proof video (v0)

Public proof that a cold Mac becomes Omakase. One take, no jump cuts that hide
time. The README plus this video are the v0 demo. SIP on. Owned launcher.
Workspace-only pills. No third-party launcher.

**Watch:** [omakase-v0.mp4](https://github.com/austindixson/omakase/releases/download/proof-v0/omakase-v0.mp4)
— release asset (prerelease tag [`proof-v0`](https://github.com/austindixson/omakase/releases/tag/proof-v0)).

Capture is complete on gHost64. The binary is not in git.

### Proof shots

- SIP on
- Tiling
- Workspace-only pills (no clock / wordmark / theme name)
- ⌘Space owned launcher
- ⌥⏎ primary (Option+Enter)
- Theme cycle Kyoto → Mocha → Ume

Shot list: [`docs/proof-video.md`](docs/proof-video.md).
Recording aid: `bin/omakase-proof-demo` (aerospace CLI + `omakase-launch` /
`omakase-theme` / `omakase-agent`).

Must show, in order:

1. **Cold Mac** — SIP enabled (`csrutil status`), no prior AeroSpace /
   SketchyBar / launcher setup (or a clearly wiped config).
2. **Install ≤10 minutes** — `./bin/install` (Homebrew, AeroSpace,
   SketchyBar, owned Omakase launcher, Super map). Wall-clock visible.
   Spotlight ⌘Space disable is **required** (uncheck Show Spotlight search).
3. **Super binds** — workspace jump, focus, move, float/fullscreen, close.
4. **Tiling + native apps** — new windows tile; workspace-only pills in
   the menu bar (no clock / wordmark / theme name). Final Cut Pro (or
   Photos / QuickTime) still opens as a normal Mac app.
5. **Owned launcher** — Super+Space opens the Omakase launcher, not
   Spotlight. Super+Return opens Ghostty or Terminal. Super+Shift+F
   opens Finder.
6. **Option+Enter primary** — focuses or launches the local coding agent
   (Cursor if present). Nothing is auto-installed.
7. **Theme cycle** — `Super+Ctrl+Shift+Space` cycles Kyoto → Mocha → Ume.
   Pills, borders, and a new Ghostty window follow.

The published file is the `proof-v0` release asset, not a path under
`docs/proof/`.

## License

[MIT](LICENSE).
