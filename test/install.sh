#!/bin/bash
# Linux-safe checks for bin/install. Does not brew-install or touch SIP.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL="${ROOT}/bin/install"
fail=0

expect() {
  local got="$1" want="$2" label="$3"
  if [ "${got}" != "${want}" ]; then
    echo "FAIL ${label}: got '${got}' want '${want}'" >&2
    fail=1
  fi
}

expect_file() {
  if [ ! -f "$1" ]; then
    echo "FAIL missing file $1" >&2
    fail=1
  fi
}

expect_absent() {
  if [ -e "$1" ]; then
    echo "FAIL leftover file $1" >&2
    fail=1
  fi
}

expect_exec() {
  if [ ! -x "$1" ]; then
    echo "FAIL not executable $1" >&2
    fail=1
  fi
}

HOME="$(mktemp -d "${TMPDIR:-/tmp}/omakase-install.XXXXXX")"
export HOME
cleanup() { rm -rf "${HOME}"; }
trap cleanup EXIT

chmod +x "${INSTALL}"

set +e
"${INSTALL}" --help >/dev/null 2>&1
code=$?
set -e
expect "${code}" "2" "help exits 2"

set +e
"${INSTALL}" >/dev/null 2>&1
code=$?
set -e
expect "${code}" "1" "full install refuses non-macOS"

"${INSTALL}" --copy-only >/dev/null

OMA="${HOME}/.config/omakase"
CFG="${HOME}/.config"

expect_file "${CFG}/aerospace/aerospace.toml"
expect_file "${CFG}/sketchybar/sketchybarrc"
expect_file "${CFG}/sketchybar/colors.sh"
expect_file "${CFG}/sketchybar/plugins/spaces.sh"
expect_absent "${CFG}/sketchybar/plugins/clock.sh"
expect_absent "${CFG}/sketchybar/plugins/front_app.sh"
expect_file "${CFG}/borders/bordersrc"
expect_file "${CFG}/ghostty/config"
expect_file "${OMA}/themes/kyoto/theme.sh"
expect_file "${OMA}/themes/mocha/theme.sh"
expect_file "${OMA}/themes/ume/theme.sh"
expect_file "${OMA}/bin/omakase-theme"
expect_file "${OMA}/bin/omakase-launch"
expect_file "${OMA}/bin/omakase-agent"
expect_file "${OMA}/bin/omakase-lock"
expect_file "${OMA}/src/launcher/Package.swift"
expect_file "${OMA}/docs/launcher.md"
expect_file "${OMA}/docs/agents.md"
expect_file "${OMA}/launch.conf"
expect_file "${OMA}/agents.conf"

expect_exec "${OMA}/bin/omakase-theme"
expect_exec "${OMA}/bin/omakase-launch"
expect_exec "${OMA}/bin/omakase-agent"
expect_exec "${OMA}/bin/omakase-lock"
expect_exec "${CFG}/sketchybar/plugins/spaces.sh"
expect_exec "${CFG}/sketchybar/sketchybarrc"
expect_exec "${CFG}/borders/bordersrc"

got="$(readlink "${OMA}/current" || true)"
case "${got}" in
  */themes/kyoto) ;;
  *)
    echo "FAIL current theme is '${got}' want */themes/kyoto" >&2
    fail=1
    ;;
esac

expect_file "${HOME}/.config/ghostty/omakase-theme"

printf 'editor=Zed\n' > "${OMA}/launch.conf"
printf 'primary=cursor\n' > "${OMA}/agents.conf"
printf '# stale\n' > "${CFG}/aerospace/aerospace.toml"
printf 'stale-clock\n' > "${CFG}/sketchybar/plugins/clock.sh"
printf 'stale-app\n' > "${CFG}/sketchybar/plugins/front_app.sh"

next="$("${INSTALL}" --copy-only)"

expect_absent "${CFG}/sketchybar/plugins/clock.sh"
expect_absent "${CFG}/sketchybar/plugins/front_app.sh"
expect_file "${CFG}/sketchybar/plugins/spaces.sh"

got="$(cat "${OMA}/launch.conf")"
expect "${got}" "editor=Zed" "re-run keeps launch.conf"

got="$(cat "${OMA}/agents.conf")"
expect "${got}" "primary=cursor" "re-run keeps agents.conf"

if grep -q 'cmd-space' "${CFG}/aerospace/aerospace.toml"; then
  :
else
  echo "FAIL re-run did not refresh aerospace.toml" >&2
  fail=1
fi

if grep -q 'alt-enter' "${CFG}/aerospace/aerospace.toml"; then
  :
else
  echo "FAIL copied Super map missing alt-enter" >&2
  fail=1
fi

if grep -q 'cmd-ctrl-enter' "${CFG}/aerospace/aerospace.toml"; then
  echo "FAIL copied Super map still has cmd-ctrl-enter" >&2
  fail=1
fi

case "${next}" in
  *'Option+Enter'*) ;;
  *)
    echo "FAIL next steps missing Option+Enter" >&2
    fail=1
    ;;
esac

case "${next}" in
  *'SwipeAeroSpace'*) ;;
  *)
    echo "FAIL next steps missing SwipeAeroSpace Accessibility" >&2
    fail=1
    ;;
esac

case "${next}" in
  *'Spotlight'*) ;;
  *)
    echo "FAIL next steps missing Spotlight" >&2
    fail=1
    ;;
esac

case "${next}" in
  *required*) ;;
  *)
    echo "FAIL next steps must require Spotlight disable" >&2
    fail=1
    ;;
esac

case "${next}" in
  *'not turned off'*)
    echo "FAIL next steps still treat Spotlight as optional" >&2
    fail=1
    ;;
esac

case "${next}" in
  *'Super+Ctrl+Return'*)
    echo "FAIL next steps still name Super+Ctrl+Return as primary" >&2
    fail=1
    ;;
esac

if ! grep -q 'uncheck Show Spotlight search' "${INSTALL}"; then
  echo "FAIL installer does not require unchecking Spotlight" >&2
  fail=1
fi

if ! grep -q 'Option+Enter' "${INSTALL}"; then
  echo "FAIL installer does not name Option+Enter" >&2
  fail=1
fi

if ! grep -q 'rm -f' "${INSTALL}"; then
  echo "FAIL installer does not rm leftover bar chrome" >&2
  fail=1
fi

if grep -R -n -i 'raycast' \
  "${INSTALL}" "${ROOT}/README.md" "${ROOT}/docs" "${ROOT}/config" "${ROOT}/bin" "${ROOT}/src"
then
  echo "FAIL third-party launcher references remain" >&2
  fail=1
fi

if grep -E -n -i 'csrutil disable|disable sip|turn sip off|sip off path' "${INSTALL}"; then
  echo "FAIL installer offers a SIP-off path" >&2
  fail=1
fi

if ! grep -q 'csrutil status' "${INSTALL}"; then
  echo "FAIL installer does not check csrutil status" >&2
  fail=1
fi

if ! grep -q 'There is no SIP-off install path' "${INSTALL}"; then
  echo "FAIL installer is not loud when SIP is off" >&2
  fail=1
fi

if ! grep -q 'mediosz/tap/swipeaerospace' "${INSTALL}"; then
  echo "FAIL installer does not install SwipeAeroSpace" >&2
  fail=1
fi

if ! grep -q 'SwipeAeroSpace' "${INSTALL}"; then
  echo "FAIL installer does not name SwipeAeroSpace" >&2
  fail=1
fi

if ! grep -q 'workspace next' "${INSTALL}"; then
  echo "FAIL installer does not say swipe maps to workspace next/prev" >&2
  fail=1
fi

if ! grep -q 'gaps.outer.top = 34' "${CFG}/aerospace/aerospace.toml"; then
  echo "FAIL copied Super map missing gaps.outer.top = 34" >&2
  fail=1
fi


python3 - "${INSTALL}" <<'PY'
import re, sys

path = sys.argv[1]
src = open(path, encoding="utf-8").read().splitlines()
fn = None
body = []
funcs = {}

def flush():
    if fn is not None:
        funcs[fn] = body[:]

for line in src:
    raw = line.split("#", 1)[0].rstrip()
    m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\(\)\s*\{?\s*$", raw)
    if m:
        flush()
        fn = m.group(1)
        body = []
        continue
    if fn is not None:
        body.append(raw)

flush()

limit = 8
worst = 0
bad = []
for name, lines in funcs.items():
    text = "\n".join(lines)
    decisions = 0
    decisions += len(re.findall(r"\b(if|elif|while|until|for|case)\b", text))
    decisions += len(re.findall(r"&&|\|\|", text))
    decisions += len(re.findall(r"^\s+[^)#\n]+\)\s*$", text, re.M))
    m = 1 + decisions
    worst = max(worst, m)
    if m > limit:
        bad.append(f"{name} M={m}")

if bad:
    print("FAIL complexity: " + "; ".join(bad), file=sys.stderr)
    sys.exit(1)
print(f"complexity ok (worst M={worst}, limit {limit})")
PY

if [ "${fail}" -ne 0 ]; then
  echo "omakase-install tests failed" >&2
  exit 1
fi
echo "ok"
