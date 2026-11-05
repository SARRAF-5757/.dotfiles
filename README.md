# Dotfiles

## All of my config files structured to set up on a Mac or Asahi Linux system using **Stow**

## Repository Structure

```text
.dotfiles/
├── common/                         # Configurations shared across all operating systems
│   ├── .clang-format               # C/C++ formatting (~/.clang-format)
│   ├── .gitconfig                  # Git & Delta config (~/.gitconfig)
│   ├── .p10k.zsh                   # Powerlevel10k config (~/.p10k.zsh)
│   ├── .wezterm.lua                # WezTerm terminal config (~/.wezterm.lua)
│   ├── .zshrc                      # Common Zsh configuration (~/.zshrc)
│   │
│   ├── .config/                    # XDG Base Directory config (~/.config)
│   │   ├── atuin/                  # Shell history (~/.config/atuin)
│   │   ├── fastfetch/              # Fastfetch system info (~/.config/fastfetch)
│   │   ├── fish/                   # Fish shell config (~/.config/fish)
│   │   ├── ghostty/                # Ghostty terminal config (~/.config/ghostty)
│   │   ├── nushell/                # Nushell config (~/.config/nushell)
│   │   ├── nvim-astronvim/         # AstroNvim distro (~/.config/nvim-astronvim)
│   │   ├── nvim-kickstart/         # Kickstart distro (~/.config/nvim-kickstart)
│   │   ├── nvim-lazyvim/           # LazyVim distro (~/.config/nvim-lazyvim, daily driver)
│   │   ├── nvim-nvchad/            # NvChad distro (~/.config/nvim-nvchad)
│   │   ├── oh-my-posh/             # Oh My Posh themes (~/.config/oh-my-posh)
│   │   ├── yazi/                   # Yazi file manager (~/.config/yazi)
│   │   └── zed/                    # Zed editor config (~/.config/zed)
│
├── macos/                          # macOS-specific configurations
│   ├── .zshrc.macos                # macOS shell additions (~/.zshrc.macos)
│   ├── Brewfile                    # Homebrew bundle (at root of macos, not stowed)
│   ├── ssh_keys.txt.pub            # SSH public key (~/ssh_keys.txt.pub)
│   │
│   ├── .config/
│   │   └── karabiner/              # Karabiner-Elements keybindings (~/.config/karabiner)
│   │
│   ├── .mac-os-debloat/            # macOS launchd debloat presets (~/.mac-os-debloat)
│   ├── .warp/                      # Warp terminal themes & keys (~/.warp)
│   │
│   ├── Applications/
│   │   └── TermVim.app             # Custom automator apps (~/Applications)
│   │
│   ├── Library/
│   │   └── Application Support/
│   │       ├── Code/User/          # VS Code macOS configs (~/Library/Application Support/Code/User)
│   │       └── Mousecape/          # Custom cursors (~/Library/Application Support/Mousecape)
│   │
│   └── scripts/                    # CLI & Raycast scripts: git-summarizer, update, debloat-sync, etc. (in PATH)
│
├── linux/                          # Fedora Asahi / KDE Plasma configurations
│   ├── .gtkrc-2.0                  # GTK 2 legacy theme config (~/.gtkrc-2.0)
│   ├── .zshrc.linux                # Linux & Wayland shell additions (~/.zshrc.linux)
│   │
│   ├── .config/                    # Linux ~/.config directory
│   │   ├── autostart/              # Autostart entries (kde-material-you-colors)
│   │   ├── Code/User/              # VS Code Linux configs (~/.config/Code/User)
│   │   ├── environment.d/          # Wayland systemd environment (~/.config/environment.d)
│   │   ├── gtk-3.0/                # GTK 3 settings (~/.config/gtk-3.0)
│   │   ├── gtk-4.0/                # GTK 4 settings (~/.config/gtk-4.0)
│   │   ├── kde-material-you-colors/# Material You color engine (~/.config/kde-material-you-colors)
│   │   ├── klassy/                 # Klassy window decoration settings (~/.config/klassy)
│   │   ├── Kvantum/                # Kvantum SVG theme engine (~/.config/Kvantum)
│   │   ├── xsettingsd/             # XSettings uniformity (~/.config/xsettingsd)
│   │   └── dolphinrc, kwinrc, ...  # KDE Plasma 6 configs & shortcuts
│   │
│   └── .local/
│       ├── bin/                    # Linux system updater (~/.local/bin/fedora-update)
│       └── share/                  # Desktop entries, KWin scripts, Plasmoids (~/.local/share)
│
├── misc/                           # Notes, keyboard layouts, phone backups, Raycast configs (not stowed)
│   ├── notes/                      # Personal notes (always-forget, nvim-forget)
│   ├── Neo60_trimode.JSON
│   ├── neo60.layout.json
│   ├── Raycast.rayconfig
│   └── Phone/
│
└── install.sh                      # Smart idempotent bootstrap installer (GNU Stow)
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

`install.sh` automatically detects the operating system and links `common/` + either `macos/` or `linux/`:

```text
Usage:
  ./install.sh [OPTIONS]

Options:
  -n, --dry-run        See what would happen if you ran it, without actually running it
  -t, --target DIR     Specify custom target directory (default is $HOME)
  -R, --restow         Restow packages (prune broken links and relink) [on by default]
  -D, --delete         Unstow / remove symlinks
  -a, --adopt          Adopt existing target files into the package repository
  -c, --common-only    Only stow common configurations
  -o, --os-only        Only stow OS-specific configurations (macos/ or linux/)
  -p, --package PKG    Only stow a specific package/app from .config/ (e.g. ghostty, zed)
  -h, --help           Show this help
```
