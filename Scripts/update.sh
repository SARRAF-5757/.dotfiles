#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Update
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ↻

# Documentation:
# @raycast.description Almost-maximizes a window and centers it using Raycast Window Management
# @raycast.author SARRAF
# @raycast.authorURL https://raycast.com/SARRAF

brew upgrade
brew cleanup
mas upgrade
open -g raycast://extensions/raycast/raycast/check-for-updates
open -g raycast://extensions/raycast/raycast/check-for-extension-updates
