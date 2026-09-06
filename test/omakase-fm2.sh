#!/bin/bash
# Linux-safe contract checks for FM-OMAKASE-2. Does not run AeroSpace.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

ok() { echo "ok $*"; }
bad() { echo "FAIL $*" >&2; fail=1; }

need_file() {
  if [ ! -f "$1" ]; then
    bad "missing $1"
    return 1
  fi
}

need_file "${ROOT}/config/aerospace/aerospace.toml"
need_file "${ROOT}/config/sketchybar/sketchybarrc"
need_file "${ROOT}/config/sketchybar/plugins/spaces.sh"
need_file "${ROOT}/config/sketchybar/README.md"
need_file "${ROOT}/docs/tiling.md"

plugin_count=0
for f in "${ROOT}/config/sketchybar/plugins/"*; do
  [ -e "$f" ] || continue
  plugin_count=$((plugin_count + 1))
  case "$(basename "$f")" in
    spaces.sh) ;;
    *) bad "extra sketchybar plugin $(basename "$f")" ;;
  esac
done
if [ "${plugin_count}" -ne 1 ]; then
  bad "plugins/ must be spaces.sh only (count=${plugin_count})"
fi

python3 - "${ROOT}/config/aerospace/aerospace.toml" <<'PY'
import sys
import tomllib

path = sys.argv[1]
with open(path, "rb") as fh:
    cfg = tomllib.load(fh)

binds = cfg["mode"]["main"]["binding"]
if "alt-enter" not in binds:
    print("FAIL aerospace: alt-enter missing", file=sys.stderr)
    sys.exit(1)
if "cmd-ctrl-enter" in binds:
    print("FAIL aerospace: cmd-ctrl-enter must be gone", file=sys.stderr)
    sys.exit(1)
if "primary" not in binds["alt-enter"]:
    print("FAIL aerospace: alt-enter must call omakase-agent primary", file=sys.stderr)
    sys.exit(1)
if cfg.get("default-root-container-layout") != "tiles":
    print("FAIL aerospace: layout must be tiles", file=sys.stderr)
    sys.exit(1)
if cfg.get("enable-normalization-flatten-containers") is not True:
    print("FAIL aerospace: flatten-containers must be true", file=sys.stderr)
    sys.exit(1)
if cfg.get("enable-normalization-opposite-orientation-for-nested-containers") is not True:
    print("FAIL aerospace: opposite-orientation must be true", file=sys.stderr)
    sys.exit(1)

gaps = cfg["gaps"]
if gaps["inner"]["horizontal"] != 8 or gaps["inner"]["vertical"] != 8:
    print("FAIL aerospace: inner gaps must be 8", file=sys.stderr)
    sys.exit(1)
for side in ("left", "right", "bottom"):
    if gaps["outer"][side] != 10:
        print(f"FAIL aerospace: outer.{side} must be 10", file=sys.stderr)
        sys.exit(1)
if gaps["outer"]["top"] != 34:
    print("FAIL aerospace: outer.top must be 34 (bar height + outer gap)", file=sys.stderr)
    sys.exit(1)

rules = cfg.get("on-window-detected") or []
runs = [row.get("run") for row in rules]
if runs[-1] != "layout tiling":
    print("FAIL aerospace: last on-window-detected must tile", file=sys.stderr)
    sys.exit(1)
float_apps = []
for row in rules:
    pred = row.get("if") or ""
    if row.get("run") == "layout floating":
        float_apps.append(pred)
need = (
    "com.apple.FinalCut",
    "com.apple.logic10",
    "com.apple.Photos",
    "com.apple.QuickTimePlayerX",
)
for app in need:
    if not any(app in pred for pred in float_apps):
        print(f"FAIL aerospace: missing float rule for {app}", file=sys.stderr)
        sys.exit(1)
print("ok aerospace.toml")
PY

bash -n "${ROOT}/config/sketchybar/sketchybarrc"
bash -n "${ROOT}/config/sketchybar/plugins/spaces.sh"
ok "sketchybar bash -n"

bar="${ROOT}/config/sketchybar/sketchybarrc"
if grep -E 'omakase\.mark|front_app|item clock|item theme' "${bar}"; then
  bad "sketchybarrc still has chrome items"
fi
if ! grep -q 'for sid in 1 2 3 4 scratch' "${bar}"; then
  bad "sketchybarrc missing workspace pills"
fi
if ! grep -q 'height=24' "${bar}"; then
  bad "sketchybarrc must be a 24px menu-bar overlay"
fi
if ! grep -q 'color=0x00000000' "${bar}"; then
  bad "sketchybarrc must be transparent over the native menu bar"
fi

docs_need_option_enter=(
  "${ROOT}/README.md"
  "${ROOT}/docs/bind-parity.md"
  "${ROOT}/config/agents/README.md"
)
for f in "${docs_need_option_enter[@]}"; do
  if ! grep -q 'Option+Enter' "$f"; then
    bad "$f missing Option+Enter"
  fi
  if grep -q 'cmd-ctrl-enter' "$f"; then
    bad "$f still names cmd-ctrl-enter"
  fi
done

if ! grep -q 'uncheck' "${ROOT}/README.md"; then
  bad "README must require unchecking Spotlight"
fi
if ! grep -q 'rm -f ~/.config/sketchybar/plugins/clock.sh' "${ROOT}/README.md"; then
  bad "README install must drop stale clock.sh"
fi
if ! grep -q 'plugins/spaces.sh' "${ROOT}/README.md"; then
  bad "README install must copy spaces.sh only"
fi
if ! grep -qi 'required' "${ROOT}/config/launcher/README.md"; then
  bad "launcher README must call Spotlight disable required"
fi
if grep -qi 'contested-chord fallback' "${ROOT}/config/launcher/README.md"; then
  bad "launcher README still treats Spotlight as contested fallback"
fi

if ! grep -qi 'dwindle' "${ROOT}/docs/tiling.md"; then
  bad "docs/tiling.md must name dwindle as unavailable"
fi
if ! grep -qi 'SIP' "${ROOT}/docs/tiling.md"; then
  bad "docs/tiling.md must name SIP"
fi
if ! grep -qi 'native macOS Spaces' "${ROOT}/docs/tiling.md"; then
  bad "docs/tiling.md must say workspaces are not native Spaces"
fi
if ! grep -q 'SwipeAeroSpace' "${ROOT}/docs/tiling.md"; then
  bad "docs/tiling.md must name SwipeAeroSpace"
fi
if ! grep -q 'outer.top = 34' "${ROOT}/docs/tiling.md"; then
  bad "docs/tiling.md must pin outer.top = 34"
fi
if ! grep -q 'SwipeAeroSpace' "${ROOT}/README.md"; then
  bad "README must name SwipeAeroSpace"
fi
if ! grep -q 'mediosz/tap/swipeaerospace' "${ROOT}/README.md"; then
  bad "README must name the SwipeAeroSpace cask"
fi
if ! grep -q 'SwipeAeroSpace' "${ROOT}/docs/bind-parity.md"; then
  bad "docs/bind-parity.md must name SwipeAeroSpace"
fi

if [ "${fail}" -ne 0 ]; then
  echo "omakase-fm2 tests failed" >&2
  exit 1
fi
echo "ok"
