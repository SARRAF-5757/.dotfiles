# Dotfiles

## All of my config files structured to set up on a Mac or Asahi Linux system using **Stow**

## Repository Structure

```text
.dotfiles/
├── common/                     # Things available on both systems (same location)
│   ├── atuin/                  # Shell history (~/.config/atuin)
│   ├── clang-format/           # C/C++ formatting (~/.clang-format)
│   ├── fastfetch/              # Cool Terminal graphics (~/.config/fastfetch)
│   ├── fish/                   # Fish shell config (~/.config/fish)
│   ├── ghostty/                # Ghostty terminal (~/.config/ghostty)
│   ├── git/                    # Git & Delta config (~/.gitconfig)
│   ├── notes/                  # Notes for myself + pub keys
│   ├── nushell/                # Nushell config (~/.config/nushell)
│   ├── nvim/                   # Multi-distro Neovim configuration
│   │   ├── nvim-astronvim/
│   │   ├── nvim-kickstart/
│   │   ├── nvim-lazyvim/       # (Daily driver)
│   │   └── nvim-nvchad/
│   ├── oh-my-posh/             # Prompt engine (~/.config/oh-my-posh)
│   ├── scripts/                # CLI scripts (~/.local/bin)
│   ├── wezterm/                # WezTerm config (~/.wezterm.lua)
│   ├── yazi/                   # Yazi file manager (~/.config/yazi)
│   └── zsh/                    # Common Zsh config & p10k (~/.zshrc, ~/.p10k.zsh)
│
├── macos/                      # macOS-specific configurations
│   ├── applications/           # Custom automator apps (~/Applications)
│   ├── brew/                   # Master Homebrew bundle (Brewfile)
│   ├── karabiner/              # Karabiner Elements keybindings (~/.config/karabiner)
│   ├── leaderkey/              # Leader Key app config (~/Leader Key)
│   ├── misc/                   # Random things not to be stowed
│   ├── mousecape/              # Custom cursors (~/Library/Application Support/Mousecape)
│   ├── scripts/                # Scripts I use on the daily (not stowed)
│   ├── vscode/                 # VS Code macOS configs (~/Library/Application Support/Code)
│   ├── warp/                   # Warp terminal themes & keys (~/.warp)
│   └── zsh/                    # macOS shell additions (~/.zshrc.macos)
│
├── linux/                      # Fedora Asahi / KDE Plasma configurations
│   ├── environment/            # Wayland systemd environment (~/.config/environment.d)
│   ├── kde/                    # KDE Plasma & KWin settings (~/.config/kdeglobals, etc.)
│   ├── scripts/                # Linux system updater (~/.local/bin/fedora-update)
│   ├── vscode/                 # VS Code Linux configs (~/.config/Code)
│   └── zsh/                    # Linux & Wayland shell additions (~/.zshrc.linux)
│
└── install.sh                  # Smart idempotent bootstrap installer (GNU Stow)
```

---

## Quick Start

### 1. Prerequisites

#### On macOS

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install GNU Stow and Git
brew install stow git
```

#### On Fedora Asahi Linux

```bash
sudo dnf install -y stow git zsh
```

---

### 2. Clone & Install

```bash
git clone https://github.com/SARRAF-5757/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Test the installation with dry-run mode
./install.sh --dry-run

# Run the installer (automatically detects OS and stows common + OS-specific packages)
./install.sh

# Reload shell
source ~/.zshrc
```

---

## More on the Installer

`install.sh` automatically detects the operating system and links `common/` + either `macos/` or `linux/`

```text
Usage:
  ./install.sh [OPTIONS]

Options:
  -n, --dry-run        See what would happen if you ran it, without actually running it
  -t, --target DIR     Specify custom target directory (default is $HOME)
  -R, --restow         Restow packages (prune broken links and relink) [on by default]
  -D, --delete         Unstow / remove symlinks
  -a, --adopt          Adopt existing target files into the package repository
  -c, --common-only    Only stow packages in common/
  -o, --os-only        Only stow packages for current OS (macos/ or linux/)
  -p, --package PKG    Only stow a specific package
  -h, --help           Show this
```
