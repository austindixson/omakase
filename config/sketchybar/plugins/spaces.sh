#!/bin/bash
# Paint one workspace pill. Event sets FOCUSED_WORKSPACE; first load queries AeroSpace.

# shellcheck disable=SC1091
source "${HOME}/.config/sketchybar/colors.sh"

sid="${NAME#space.}"
focused="${FOCUSED_WORKSPACE:-}"
if [ -z "${focused}" ]; then
  focused="$(aerospace list-workspaces --focused 2>/dev/null || true)"
fi

if [ "${sid}" = "${focused}" ]; then
  sketchybar --set "${NAME}" \
    icon.color="${BAR_ACCENT:-0xffc23a2b}" \
    background.drawing=on \
    background.color="${BAR_SURFACE:-0xff2a2722}"
else
  sketchybar --set "${NAME}" \
    icon.color="${BAR_MUTED:-0xff8a8278}" \
    background.drawing=off
fi
