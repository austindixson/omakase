#!/bin/bash
# Workspace pills read the active Omakase theme. Fallback is Kyoto so a
# copied bar still paints before the first `omakase-theme` run.

_current="${HOME}/.config/omakase/current/theme.sh"
_kyoto="${HOME}/.config/omakase/themes/kyoto/theme.sh"

if [ -f "${_current}" ]; then
  # shellcheck disable=SC1090
  source "${_current}"
elif [ -f "${_kyoto}" ]; then
  # shellcheck disable=SC1090
  source "${_kyoto}"
fi
