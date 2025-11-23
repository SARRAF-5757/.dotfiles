## To replicate on a new machine-

1. Setup ssh key with github
2. Install [Homebrew](https://brew.sh/)
3. Clone repository
4. Install from Brewfile '''brew bundle --file=~/.dotfiles/Brewfile'''
5. Run '''stow .'''

## Things Included

- **Homebrew**: Brewfile to install all the tools necessary + casks that I use personally
- **Shell Configurations**: My daily driver is ZSH, but fish and nu are also there for playing around. ZSH config includes aliases, plugins, and themes.
- **Terminal Enhancements**: Improved `ls` (using `eza`), `cat` (using `bat`), and navigation (`zoxide`).
- **Terminal Configurations**: [Ghostty](https://ghostty.org/)and [Wezterm](https://wezterm.org/) configs available. Tweaks are made for a transparent and minimal terminal setup
- **Warp Terminal Themes**: Some custom themes made for [Warp Terminal](https://www.warp.dev/download)
- **Multi-distro Neovim Setup**: My daily driver is LazyVim, others aren't really configured, just there for playing around.
- **Yazi Configuration**: Terminal file browser yazi setup to work with the multi-distro neovim setup.
- **Git Config**: Use [Delta](https://github.com/dandavison/delta) for prettier git diff.
- **VS Code Configuration**: Minimal VS Code setup with various utilities and custom CSS & JS + Keybindings using Hyperkey
- **Custom CSS for Zen Browser**: My custom transparent and minimal setup for the [Zen Browser](https://zen-browser.app/) (Now available as a standalone - [BlackGlass](https://github.com/SARRAF-5757/BlackGlass))
- **Scripts**: Some useful scripts I use on the daily
- **Leader Key Keybindings**: My command set for [Leader Key](https://github.com/mikker/LeaderKey.app) App
- **Karabiner Elements Config**: Complex modifications to add hyperkey, vim motions, home row mods, etc
- **Raycast Configuration**: Password-locked for security, only stored here for personal use
