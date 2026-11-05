#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title low-power-mode
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔋🪫

# Documentation:
# @raycast.description Toggle low power mode on mac
# @raycast.author SARRAF
# @raycast.authorURL https://raycast.com/SARRAF

ON="sudo pmset -a lowpowermode 1"
OFF="sudo pmset -a lowpowermode 0"

# Temporary state file
STATE_FILE="tmp/lpm-state"

if [ ! -f "$STATE_FILE" ]; then
  # run for the first time if it hasn't been run before
  eval "$ON"
  echo "ON" >"$STATE_FILE"
else
  LAST_RUN=$(cat "$STATE_FILE")

  if [ "$LAST_RUN" = "ON" ]; then
    eval "$OFF"
    echo "OFF" >"$STATE_FILE"
  else
    eval "$ON"
    echo "ON" >"$STATE_FILE"
  fi
fi
