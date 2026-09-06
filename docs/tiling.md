# Tiling — AeroSpace (SIP on) vs Hyprland

Omakase is not a Hyprland port. The engine is AeroSpace on top of the
macOS window server. This page records what the Super map can make feel
closer to Omarchy, and what SIP-on AeroSpace cannot do.

## What this config does (Hyprland-feel)

Pinned in `config/aerospace/aerospace.toml`:

| Knob | Value | Why |
| --- | --- | --- |
| `default-root-container-layout` | `tiles` | Not accordion. New workspaces split like Hyprland tiles. |
| `default-root-container-orientation` | `auto` | Wide monitor → horizontal; tall → vertical. |
| `enable-normalization-flatten-containers` | `true` | Drop single-child containers so the tree stays flat. |
| `enable-normalization-opposite-orientation-for-nested-containers` | `true` | Nested splits flip axis (closest AeroSpace analog to Hyprland dwindle nesting). |
| Gaps | inner 8 / outer 10 | Hyprland-ish `gaps_in` / `gaps_out`. One set, not per-theme. Left / right / bottom stay 10. |
| New windows | tile | Catch-all `layout tiling`. Float is only Final Cut, Logic, Photos, QuickTime. |
| Bar gap | outer.top = 34 | SketchyBar workspace pills are 24px (`config/sketchybar/sketchybarrc`). The bar’s bottom is the top of the tiling view — tiles must not overlap it. 34 = 24 (documented bar height) + 10 (Hyprland outer). A 22px live bar is still cleared (22 + 12). If bar height changes, keep `gaps.outer.top` = height + 10. |

Normalization defaults were already `true` in AeroSpace if omitted. We
pin them so a later default change cannot silently accordion the tree.

## What was a config miss (not an SIP wall)

These felt “not Hyprland” and were ours to fix:

- Fat Omarchy SketchyBar (wordmark, clock, theme name) plus a 40px top
  gap. The native menu bar already has clock and battery. The bar is now
  workspace pills only. `gaps.outer.top` still has to clear that strip
  (24 + 10 = 34) so tiles sit below the pills, not under them.
- Normalization keys were not written down. Easy to assume accordion or
  a messy i3 tree.
- New-window intent was implicit (AeroSpace default = tile). The
  catch-all makes “float only the Apple pro apps” a contract.

## What SIP-on AeroSpace cannot do

These are engine / OS limits. Do not paper over them in the Super map.

| Hyprland / Omarchy | AeroSpace (SIP on) |
| --- | --- |
| Dwindle (binary split tree) | i3-style container tree. `tiles` + opposite-orientation nesting is the closest feel. There is no dwindle algorithm. |
| Master layout | Not available. |
| Compositor animations, blur, rounded window chrome | No. macOS owns compositing. JankyBorders is an overlay stroke, not a compositor. |
| `special:scratchpad` | Named workspace `scratch` with `--auto-back-and-forth`. Not a real special workspace. |
| Window swallowing, group tabs, sticky pop-out | Deferred. No honest equivalent without inventing one. |
| Replace the window server | Never. AeroSpace tiles via Accessibility (AX). Sheets, some dialogs, and native fullscreen Spaces are AX-limited. |
| Native macOS Spaces / Mission Control desktops | Never the engine. AeroSpace **emulates** virtual workspaces; it does not create or switch real Spaces. See below. |
| yabai scripting / SIP off | Out of product. SIP stays on. |

AeroSpace also cannot span a window across monitors (macOS limit) and
cannot disable Mission Control space-switch animation (Reduce Motion
only makes it shorter).

## Workspaces are not native Spaces (SIP on)

This is a product limit, not a missing config key.

AeroSpace reimplements Spaces and calls them workspaces. Inactive
workspace windows are parked off-screen; switching a workspace moves
those windows back. It does **not** use native macOS Spaces. That is
by design, and it is why Omakase keeps SIP on.

Consequences:

- 3-finger swipe on a stock Mac switches **Spaces**, not AeroSpace
  workspaces. Those are different objects.
- There is no AeroSpace bind that “becomes a Space.” Do not invent one.
- Omakase will not disable SIP, will not switch the engine to yabai,
  and will not make native Spaces the default, to get swipe-between-desktops.

The official path for “swipe like fullscreen Spaces” is a gesture helper
from [AeroSpace goodies](https://nikitabobko.github.io/AeroSpace/goodies)
that runs the real commands `aerospace workspace next` and
`aerospace workspace prev`:

| Helper | Role |
| --- | --- |
| **SwipeAeroSpace** (recommended) | `brew install --cask mediosz/tap/swipeaerospace`. 3-finger swipe → `workspace next` / `prev`. Cold-Mac `./bin/install` installs this cask. Grant Accessibility, then open the app and leave it running. |
| aerospace-swipe | Another goodies-listed helper. Same idea: map a gesture to those commands. |
| BetterTouchTool | Same commands, if you already pay for BTT. Not shipped. |

`./bin/install` treats SwipeAeroSpace as the cold-Mac swipe helper.
Accessibility is a captain step — the script cannot grant it.

`Super+Tab` / `Super+Shift+Tab` stay the macOS app switcher. Sequential
workspace walk is the swipe helper, not a stolen Tab chord. See
`docs/bind-parity.md`.

## What Super+T still is

`Super+T` toggles `layout floating tiling` for the focused window. That
is the escape hatch. Default path is tile.

Accordion exists in AeroSpace (`layout accordion`). Omakase does not
bind it. Super+L (dwindle ↔ scrolling) stays deferred — that pair is
Hyprland-only.
