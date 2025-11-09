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
echo " "
echo " "
echo " "
echo "Updating App Store..."
mas upgrade
echo " "
echo " "
echo " "
echo "Updating raycast extensions..."
open -g raycast://extensions/raycast/raycast/check-for-extension-updates
echo " "
echo " "
echo "Updating Raycast..."
open -g raycast://extensions/raycast/raycast/check-for-updates
echo " "
echo " "
echo "Updating OMP..."
oh-my-posh upgrade
echo "Update Finished" | figlet | lolcat
echo " "
echo " "
