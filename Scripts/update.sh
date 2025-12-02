#!/bin/zsh
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

# Color Variables
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RED='\033[1;31m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color

print "${YELLOW}\ue7fd Updating Brew...${NC}"
brew upgrade
brew cleanup
print " "
print " "
print "${BLUE}\ue711 Updating App Store...${NC}"
mas upgrade
print " "
print " "
print "${RED}\ueae6 Updating raycast extensions...${NC}"
open -g raycast://extensions/raycast/raycast/check-for-extension-updates
print " "
print " "
print "${RED}\ueac9 Updating Raycast...${NC}"
open -g raycast://extensions/raycast/raycast/check-for-updates
print " "
print " "
print "${PURPLE}\uf489 Updating OMP...${NC}"
oh-my-posh upgrade
print "Update Finished" | figlet | lolcat
print " "
print " "
