#!/bin/bash
# Clock. Theme colors are applied by sketchybarrc on reload.

sketchybar --set "${NAME:-clock}" label="$(date '+%a %H:%M')"
