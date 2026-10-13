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

if command -v mas &>/dev/null; then
  print "${BLUE}\ue711 Updating App Store...${NC}"
  mas upgrade
  print " "
  print " "
fi

print "${BLUE}\uf179 Checking macOS Updates...${NC}"
softwareupdate -l
print " "
print " "

if command -v bun &>/dev/null; then
  print "${YELLOW}\uf12e Updating Bun & Global Packages...${NC}"
  bun upgrade 2>/dev/null || true
  bun update -g 2>/dev/null || true
  print " "
  print " "
fi

if command -v uv &>/dev/null; then
  print "${GREEN}\ue73c Updating Python Tools (uv)...${NC}"
  uv tool upgrade --all 2>/dev/null || true
  print " "
  print " "
fi

if command -v rustup &>/dev/null; then
  print "${RED}\ue7a8 Updating Rustup Toolchains...${NC}"
  rustup update
  print " "
  print " "
fi

if command -v cargo-install-update &>/dev/null; then
  print "${RED}\ue7a8 Updating Cargo Crates...${NC}"
  cargo install-update -a
  print " "
  print " "
elif command -v cargo &>/dev/null; then
  print "${RED}\ue7a8 Cargo installed (run 'brew install cargo-update' to enable crate auto-updates)${NC}"
  print " "
  print " "
fi

if command -v go &>/dev/null; then
  print "${CYAN}\ue627 Updating Go Tools...${NC}"
  go install golang.org/x/tools/gopls@latest 2>/dev/null || true
  print " "
  print " "
fi

if command -v gem &>/dev/null; then
  print "${RED}\ue739 Updating RubyGems...${NC}"
  gem update --system 2>/dev/null || true
  gem update 2>/dev/null || true
  print " "
  print " "
fi

if command -v tldr &>/dev/null; then
  print "${CYAN}\uf02d Updating TLDR Pages...${NC}"
  tldr --update 2>/dev/null || true
  print " "
  print " "
fi

if [[ -n "$ZSH" && -d "$ZSH" ]]; then
  print "${PURPLE}\uf1d3 Updating Oh My Zsh...${NC}"
  $ZSH/tools/upgrade.sh 2>/dev/null || true
  print " "
  print " "
fi

if command -v oh-my-posh &>/dev/null; then
  print "${PURPLE}\uf489 Updating OMP...${NC}"
  oh-my-posh upgrade
  print " "
  print " "
fi

if command -v nvim &>/dev/null; then
  print "${CYAN}\uf36f Updating Neovim Plugins...${NC}"
  nvim "+Lazy! sync" +qa
  print " "
  print " "
fi

print "${RED}\ueae6 Updating raycast extensions...${NC}"
open -g raycast://extensions/raycast/raycast/check-for-extension-updates
print " "
print " "
print "${RED}\ueac9 Updating Raycast...${NC}"
open -g raycast://extensions/raycast/raycast/check-for-updates
print " "
print " "
print "Update Finished" | figlet | lolcrab
