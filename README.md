## Features
- **Zsh Configuration**: Includes aliases, plugins, and themes (Powerlevel10k).
- **Terminal Enhancements**: Improved `ls` (using `eza`), `cat` (using `bat`), and navigation (`zoxide`).
- **VS Code Configuration**: Minimal VS Code setup with various utilities and custom CSS & JS + Keybindings using Hyperkey

## Installation
To copy these setup files:

### 1. Clone the Repository
```sh
git clone https://github.com/SARRAF-5757/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run the Setup Script
To create symbolic links to the appropriate locations.

```sh
./install.sh
```

### 3. Restart Your Shell
```sh
exec zsh
```

## Tools Used
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Zsh Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Zsh Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Eza (Modern ls)](https://github.com/eza-community/eza)
- [Bat (Better cat)](https://github.com/sharkdp/bat)
- [Zoxide (Faster cd)](https://github.com/ajeetdsouza/zoxide)
