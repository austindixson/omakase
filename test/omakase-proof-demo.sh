#!/bin/bash
# Linux-safe checks for the v0 proof driver and shot list.
# Does not run AeroSpace, install, or capture video.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEMO="${ROOT}/bin/omakase-proof-demo"
fail=0

expect() {
  local got="$1" want="$2" label="$3"
  if [ "${got}" != "${want}" ]; then
    echo "FAIL ${label}: got '${got}' want '${want}'" >&2
    fail=1
  fi
}

need_file() {
  if [ ! -f "$1" ]; then
    echo "FAIL missing $1" >&2
    fail=1
  fi
}

need_file "${DEMO}"
need_file "${ROOT}/docs/proof-video.md"
need_file "${ROOT}/docs/proof/README.md"

chmod +x "${DEMO}"
bash -n "${DEMO}"

set +e
"${DEMO}" --help >/dev/null 2>&1
code=$?
set -e
expect "${code}" "2" "help exits 2"

plan="$("${DEMO}" --print)"

need_line() {
  local needle="$1"
  case "${plan}" in
    *"${needle}"*) ;;
    *)
      echo "FAIL --print missing '${needle}'" >&2
      fail=1
      ;;
  esac
}

need_line $'note\tcold:'
need_line $'note\tinstall:'
need_line "Spotlight"
need_line $'aerospace\tworkspace 2'
need_line $'aerospace\tworkspace 1'
need_line $'aerospace\tfocus right'
need_line $'aerospace\tmove left'
need_line $'aerospace\tlayout floating tiling'
need_line $'launch\tterminal'
need_line $'launch\tfiles'
need_line $'launch\tui'
need_line $'agent\tlist'
need_line $'agent\tprimary'
need_line $'theme\tkyoto'
need_line $'theme\tcycle'

docs="${ROOT}/docs/proof-video.md"
asset="https://github.com/austindixson/omakase/releases/download/proof-v0/omakase-v0.mp4"
release="https://github.com/austindixson/omakase/releases/tag/proof-v0"
for needle in "Option+Enter" "Spotlight" "workspace pills" "owned launcher" "SIP" "## Proof shots" "${asset}" "${release}"; do
  if ! grep -q "${needle}" "${docs}"; then
    echo "FAIL docs/proof-video.md missing ${needle}" >&2
    fail=1
  fi
done

if ! grep -q 'omakase-v0.mp4' "${ROOT}/docs/proof/README.md"; then
  echo "FAIL docs/proof/README.md must name omakase-v0.mp4" >&2
  fail=1
fi
if ! grep -q "${asset}" "${ROOT}/docs/proof/README.md"; then
  echo "FAIL docs/proof/README.md must link the proof-v0 asset" >&2
  fail=1
fi
if ! grep -q "${asset}" "${ROOT}/README.md"; then
  echo "FAIL README must link the proof-v0 asset" >&2
  fail=1
fi

if grep -q 'cmd-ctrl-enter' "${docs}" "${DEMO}"; then
  echo "FAIL proof files still name cmd-ctrl-enter" >&2
  fail=1
fi

if grep -qi 'contested-chord fallback' "${docs}"; then
  echo "FAIL proof-video still treats Spotlight as contested" >&2
  fail=1
fi

if grep -R -n -i 'raycast' "${DEMO}" "${ROOT}/docs/proof-video.md" "${ROOT}/docs/proof"; then
  echo "FAIL proof slice names a third-party launcher" >&2
  fail=1
fi

python3 - "${DEMO}" <<'PY'
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
  echo "omakase-proof-demo tests failed" >&2
  exit 1
fi
echo "ok"
