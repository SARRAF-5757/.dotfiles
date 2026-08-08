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
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

print "${YELLOW}\ue7fd Updating Brew...${NC}"
brew update && brew upgrade && brew cleanup
print " "
print " "
print "${BLUE}\ue711 Updating App Store...${NC}"
mas upgrade
print " "
print " "
print "${BLUE}\uf179 Checking macOS Updates...${NC}"
softwareupdate -l
print " "
print " "
print "${GREEN}\ue71e Updating npm...${NC}"
npm install -g npm@latest
npm update -g
print " "
print " "
print "${PURPLE}\uf1d3 Updating Oh My Zsh...${NC}"
$ZSH/tools/upgrade.sh
print " "
print " "
print "${PURPLE}\uf489 Updating OMP...${NC}"
oh-my-posh upgrade
print " "
print " "
print "${CYAN}\uf36f Updating Neovim Plugins...${NC}"
nvim "+Lazy! sync" +qa
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
print "Update Finished" | figlet | lolcat

