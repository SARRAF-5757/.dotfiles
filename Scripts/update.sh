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

echo "Updating Brew..."
brew upgrade
brew cleanup
echo "Updating App Store..."
mas upgrade
echo "Updating zsh..."
omz update
echo "Updating raycast extensions..."
open -g raycast://extensions/raycast/raycast/check-for-extension-updates
echo "Updating Raycast..."
open -g raycast://extensions/raycast/raycast/check-for-updates
echo "Update Finished" | figlet | lolcat
