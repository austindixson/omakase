# Workspace pills — native menu bar only

SketchyBar is not an Omarchy status bar. It overlays the Mac menu bar
with AeroSpace workspace pills (1–4 + scratch). That is the whole UI.

Apple already owns clock and battery. Themes paint pill colors, then
JankyBorders and Ghostty. They do not add bar chrome.

## What cold install copies

`./bin/install` and the README manual path copy this directory as-is:

```
sketchybarrc          24px transparent overlay
colors.sh             active theme tokens
plugins/spaces.sh     one pill
```

Do not add `clock.sh`, `front_app.sh`, a wordmark, weather, or a theme
name. A re-copy must delete those if a previous install left them.

## What not to add

- Clock, battery, weather, front-app, wordmark, theme-name widgets
- A full-width themed bar (the rejected FM-OMAKASE-1 chrome)
- Hiding the native menu bar
- Screen Recording / notch widgets
