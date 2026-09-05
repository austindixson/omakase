#!/bin/bash
# Minimal clock so the SketchyBar stub has one live item.
# Themes will restyle this; do not add a widget farm here.

sketchybar --set clock label="$(date '+%a %H:%M')"
