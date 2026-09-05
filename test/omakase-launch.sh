#!/bin/bash
# Linux-safe checks for bin/omakase-launch. Does not exec macOS UI.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LAUNCH="${ROOT}/bin/omakase-launch"
LOCK="${ROOT}/bin/omakase-lock"
STATE="$(mktemp -d "${TMPDIR:-/tmp}/omakase-launch.XXXXXX")"
APPS="${STATE}/apps"
fail=0

cleanup() { rm -rf "${STATE}"; }
trap cleanup EXIT

mkdir -p "${APPS}/Ghostty.app" "${APPS}/1Password.app" "${STATE}/bin"
cp "${LOCK}" "${STATE}/bin/omakase-lock"
chmod +x "${LAUNCH}" "${STATE}/bin/omakase-lock"

run() {
  OMAKASE_STATE="${STATE}" OMAKASE_APP_ROOT="${APPS}" "$@"
}

expect() {
  local got="$1" want="$2" label="$3"
  if [ "${got}" != "${want}" ]; then
    echo "FAIL ${label}: got '${got}' want '${want}'" >&2
    fail=1
  fi
}

got="$(run "${LAUNCH}" --print terminal)"
expect "${got}" $'app\tGhostty' "terminal prefers Ghostty"

rmdir "${APPS}/Ghostty.app"
got="$(run "${LAUNCH}" --print terminal)"
expect "${got}" $'app\tTerminal' "terminal falls back to Terminal"

got="$(run "${LAUNCH}" --print browser)"
expect "${got}" $'app\tSafari' "browser defaults to Safari"

printf 'browser=Orion\n' > "${STATE}/launch.conf"
got="$(run "${LAUNCH}" --print browser)"
expect "${got}" $'app\tSafari' "missing override app still falls back to Safari"
printf 'browser=Safari\neditor=TextEdit\n' > "${STATE}/launch.conf"

got="$(run "${LAUNCH}" --print files)"
expect "${got}" $'app\tFinder' "files opens Finder"

got="$(run "${LAUNCH}" --print editor)"
expect "${got}" $'app\tTextEdit' "editor defaults to TextEdit"

got="$(run "${LAUNCH}" --print music)"
expect "${got}" $'app\tMusic' "music opens Music"

got="$(run "${LAUNCH}" --print passwords)"
expect "${got}" $'app\t1Password' "passwords finds 1Password"

rmdir "${APPS}/1Password.app"
got="$(run "${LAUNCH}" --print passwords)"
expect "${got}" $'skip\t1Password' "passwords skips when missing"

got="$(run "${LAUNCH}" --print lock)"
expect "${got}" $'lock\t'"${STATE}/bin/omakase-lock" "lock delegates to omakase-lock"

got="$(run "${LAUNCH}" --print sleep)"
expect "${got}" $'sleep\tpmset' "sleep plans pmset"

got="$(run "${LAUNCH}" --print restart)"
expect "${got}" $'restart\tosascript' "restart plans osascript"

got="$(run env OMAKASE_LAUNCHER=osascript "${LAUNCH}" --print ui)"
expect "${got}" $'ui\tosascript' "ui backend can be forced"

got="$(run env OMAKASE_LAUNCHER=osascript OMAKASE_LAUNCH_QUERY=lock "${LAUNCH}" --print ui)"
expect "${got}" $'query\tLock Screen' "query lock"

got="$(run env OMAKASE_LAUNCHER=osascript OMAKASE_LAUNCH_QUERY=term "${LAUNCH}" --print ui)"
expect "${got}" $'query\tTerminal' "query term"

got="$(run env OMAKASE_SYSTEM_PICK=sleep "${LAUNCH}" --print system)"
expect "${got}" $'sleep\tpmset' "system pick sleep"

set +e
"${LAUNCH}" --help >/dev/null 2>&1
code=$?
set -e
expect "${code}" "2" "help exits 2"

got="$(run "${LAUNCH}" --print system)"
expect "${got}" $'system\tlock,sleep,restart' "system lists verbs"

if grep -R -n -i 'raycast' \
  "${ROOT}/README.md" "${ROOT}/docs" "${ROOT}/config" "${ROOT}/bin" "${ROOT}/src"
then
  echo "FAIL launcher-adjacent Raycast references remain" >&2
  fail=1
fi

if [ "${fail}" -ne 0 ]; then
  echo "omakase-launch tests failed" >&2
  exit 1
fi
echo "ok"
