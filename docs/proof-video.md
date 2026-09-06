# Proof video (v0)

Public proof that a cold Mac becomes Omakase. One take. No jump cuts that
hide time. SIP on. Owned launcher. Workspace-only pills. No third-party
launcher.

**Watch:** [omakase-v0.mp4](https://github.com/austindixson/omakase/releases/download/proof-v0/omakase-v0.mp4)
— release asset (prerelease tag [`proof-v0`](https://github.com/austindixson/omakase/releases/tag/proof-v0)).

Capture is complete on gHost64 (`~/Desktop/omakase-proof.mp4`). The public
file is published under prerelease tag `proof-v0` as `omakase-v0.mp4`. The
binary is not in this tree.

The README criteria and this shot list are the same path. Recording aid
after install: `bin/omakase-proof-demo` (or `--print` for the plan). The
script does not install, does not uncheck Spotlight, and does not capture
video.

## Proof shots

What the gHost64 take shows:

- SIP on (`csrutil status`: enabled)
- Tiling — new windows tile; Hyprland-ish gaps
- Workspace-only pills in the native menu bar (no clock / wordmark / theme name)
- ⌘Space owned launcher (Spotlight’s ⌘Space unchecked; not a third-party launcher)
- ⌥⏎ primary local agent (Option+Enter)
- Theme cycle Kyoto → Mocha → Ume (pills, borders, Ghostty)

## Shot list

### 1. Cold Mac

- `csrutil status` on camera. Expected: System Integrity Protection
  status: enabled.
- No prior AeroSpace / SketchyBar / launcher setup, or a clearly wiped
  `~/.config/aerospace`, `~/.config/sketchybar`, `~/.config/omakase`.
- Native menu bar only. No leftover clock / wordmark chrome.

Human. The driver prints this beat; it does not wipe configs.

### 2. Install ≤10 minutes

- Wall-clock visible.
- `./bin/install` from a clone (Homebrew, AeroSpace, SketchyBar,
  JankyBorders, Ghostty, Super map, workspace pills, owned launcher).
- Accessibility prompt for AeroSpace — grant it.
- **Required:** System Settings → Keyboard → Keyboard Shortcuts →
  Spotlight → uncheck **Show Spotlight search**. Super+Space only wins
  after that.

Human. The driver does not run the installer.

### 3. Super binds

Section A, live in AeroSpace. Show:

- Workspace jump: `Super+1` / `Super+2` (pills in the native menu bar)
- Focus: `Super+Arrow`
- Move: `Super+Shift+Arrow`
- Float / tile: `Super+T`
- Fullscreen: `Super+F` (optional; skip if it swallows the recording)
- Close: `Super+W` on a disposable window — not the recorder

Driver (after two tiled windows exist): `aerospace workspace 2`,
`workspace 1`, `focus right`, `move left`, `layout floating tiling`
twice.

### 4. Tiling + native apps

- New Ghostty / Finder windows tile. Gaps read Hyprland-ish
  (inner 8 / outer 10). See [`tiling.md`](tiling.md).
- Workspace pills only — no clock, battery widget, wordmark, or theme
  name on the bar. macOS already owns clock and battery.
- Final Cut Pro still opens as a normal Mac app (float rule). If FCP is
  missing, Photos or QuickTime. Native. Not tiled away.

Driver opens Ghostty (`omakase-launch terminal`) and Finder
(`omakase-launch files`) so the tree is visible. Apple pro apps stay a
human beat (`open -a` / the Dock).

### 5. Owned launcher

- `Super+Space` opens the Omakase launcher, not Spotlight.
- `Super+Return` opens Ghostty (or Terminal.app).
- `Super+Shift+F` opens Finder.

Driver prints the Super+Space plan (`omakase-launch --print ui`) and
does not open the panel — a prompt would stall the take. Play
Super+Space by hand on camera.

### 6. Option+Enter primary

- `Option+Enter` focuses or launches the primary local agent (Cursor if
  present).
- `Super+Shift+Ctrl+A` may list what is already on this Mac. Nothing is
  auto-installed.

Driver: `omakase-agent list` then `omakase-agent primary`.

### 7. Theme cycle

- `Super+Ctrl+Shift+Space` cycles Kyoto → Mocha → Ume.
- Workspace pills, JankyBorders, and a new Ghostty window follow.
- No theme-name widget.

Driver paints Kyoto first, then `omakase-theme cycle` twice so Mocha and
Ume land on camera.

## How to record

1. Start screen recording (or QuickTime). Wall-clock in frame.
2. Film shots 1–2 by hand: SIP, `./bin/install`, Spotlight uncheck.
3. Film shots 3–7 by hand, or run `bin/omakase-proof-demo` in Ghostty
   and play Super+Space / Option+Enter / Final Cut yourself where the
   script only prints a plan.
4. Stop. The published take is the `proof-v0` release asset above, not a
   file in `docs/proof/`.

`PROOF_PAUSE` (seconds, default `1`) spaces driver steps. The public
take is still one continuous recording.
