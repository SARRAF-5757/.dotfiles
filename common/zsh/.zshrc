#!----------------------------Powerlevel10k----------------------------!#
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# ZSH_THEME="powerlevel10k/powerlevel10k"

#!------------------------------VARIABLES------------------------------!#
export ZSH="$HOME/.oh-my-zsh" # Path to Oh My Zsh installation

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

#!-----------------------------OMZ PLUGINS----------------------------!#
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    git
    vscode
    eza
    zoxide
    colored-man-pages
    colorize
    thefuck
    themes
)

# only on mac
if [[ "$(uname -s)" == "Darwin" ]]; then
    plugins+=(macos brew)
fi

#!----------------------PLUGIN CONFIGURATIONS-----------------------!#
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#3e3e3e,bold"
ZSH_AUTOSUGGEST_STRATEGY=(completion match_prev_cmd)

#!----------------------LOAD ZSH WITH OPTIONS-----------------------!#
# CASE_SENSITIVE="true"                 # case-sensitive completion
# HYPHEN_INSENSITIVE="true"             # hyphen-insensitive completion (Case-sensitive must be off)
# zstyle ':omz:update' mode disabled    # disable automatic updates
# zstyle ':omz:update' mode auto        # update automatically without asking
# zstyle ':omz:update' mode reminder    # just remind me to update when it's time
# zstyle ':omz:update' frequency 13     # update frequency in days
# DISABLE_MAGIC_FUNCTIONS="true"        # fix pasting URLs if messed up
# DISABLE_LS_COLORS="true"              # disable colors in ls
DISABLE_AUTO_TITLE="true"               # disable auto-setting terminal title
# ENABLE_CORRECTION="true"              # enable command auto-correction
# COMPLETION_WAITING_DOTS="%F{red}waiting...%f"   # display red dots whilst waiting for completion
# DISABLE_UNTRACKED_FILES_DIRTY="true"  # disable marking untracked files under VCS as dirty
# HIST_STAMPS="mm/dd/yyyy"              # change time stamp format in the history command output
# ZSH_CUSTOM=/path/to/new-custom-folder # if using custom folder than $ZSH/custom

# Load Oh My Zsh
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

##!-------------------------LOAD ZSH THEME--------------------------!#
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    if command -v oh-my-posh &>/dev/null; then
        # eval "$(oh-my-posh init zsh --config ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/mytheme.omp.json --trace)"
        # eval "$(oh-my-posh init zsh --config ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/nightowl.omp.json --trace)"
        # eval "$(oh-my-posh init zsh --config ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/atomic.omp.json --trace)"
        # eval "$(oh-my-posh init zsh --config ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/bubbles.omp.json --trace)"
        eval "$(oh-my-posh init zsh --config ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/chips.omp.json --trace)"
        # eval "$(oh-my-posh init zsh --config ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/catppuccin.omp.json --trace)"
    fi
fi

#!------------------------------KEYBINDS------------------------------!#
bindkey '^I' autosuggest-accept
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down 

#!-------------------------------ALIASES------------------------------!#
if command -v eza &>/dev/null; then
    alias ls='eza --width 70 --no-quotes --icons=always --color=always -a'
    alias lss='eza -l --icons=always --total-size --git --no-user --no-permissions --no-time'
    alias tree='eza -T --total-size --no-quotes --icons=always --color=always'
    alias tre='eza -T --total-size --no-quotes --icons=always --color=always -L 2'
else
    alias ls='ls --color=auto -a'
    alias lss='ls -lah'
fi

if command -v bat &>/dev/null; then
    alias cat='bat'
elif command -v batcat &>/dev/null; then
    alias cat='batcat'
fi

if command -v zoxide &>/dev/null; then
    alias cd='z'
fi

if command -v fd &>/dev/null; then
    alias find='fd'
elif command -v fdfind &>/dev/null; then
    alias find='fdfind'
fi

alias e='yazi'
alias t='btop'
alias ff='fastfetch'
alias of="onefetch --http-url --disabled-fields=churn"
alias disk='diskonaut'
alias gits='git status'
alias gitd='git diff'
alias gitr='git remote show origin'
alias gl=carbonyl_url
alias google=google
alias gemini=agy

# Multi-distro neovim setup
alias avim='NVIM_APPNAME="nvim-astronvim" nvim'
alias vim='NVIM_APPNAME="nvim-lazyvim" nvim'
alias chvim='NVIM_APPNAME="nvim-nvchad" nvim'
alias kvim='NVIM_APPNAME="nvim-kickstart" nvim'

#!-----------------------------FUNCTIONS----------------------------!#
function title() {          # Customize tab titles
    echo -en "\e]2;$@\a"
}

function carbonyl_url() {
    if command -v carbonyl &>/dev/null; then
        carbonyl "https://$1"
    else
        echo "carbonyl not installed"
    fi
}

function google() {
    if command -v carbonyl &>/dev/null; then
        carbonyl "https://www.google.com/search?q=$1"
    else
        echo "carbonyl not installed"
    fi
}

function cls() {            # Similar clear logic to cd
    clear
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo ""
        command -v onefetch &>/dev/null && onefetch --http-url --disabled-fields=churn
        echo ""
    else
        command -v fastfetch &>/dev/null && fastfetch
    fi
}

# Atuin shell history
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

#!----------------------SETUP AUTO FETCHING-------------------------!#
last_repository="" # Variable to track the last repo we were in

checkGitDir() {
    current_repository=$(git rev-parse --show-toplevel 2> /dev/null)

    if [[ -n "$current_repository" ]]; then
        # If in a repo, and it's different from the last one we saw...
        if [[ "$current_repository" != "$last_repository" ]]; then
            echo ""
            command -v onefetch &>/dev/null && onefetch --http-url --disabled-fields=churn
            echo ""
            last_repository="$current_repository"
        fi
    else
        # If not in a repo, reset the tracker so onefetch runs if we re-enter later
        last_repository=""
    fi
}

autoload -U add-zsh-hook # Hook the change-directory event
add-zsh-hook chpwd checkGitDir

#!----------------------------COMPLETIONS---------------------------!#
if [[ -d "$HOME/.docker/completions" ]]; then
    fpath=("$HOME/.docker/completions" $fpath)
fi
autoload -Uz compinit
compinit -u

#!--------------------------STARTUP COMMANDS-------------------------!#
if git rev-parse --is-inside-work-tree &>/dev/null; then # If we started inside a git repo
    echo ""
    command -v onefetch &>/dev/null && onefetch --http-url --disabled-fields=churn
    echo ""
    last_repository=$(git rev-parse --show-toplevel 2> /dev/null)
else
    command -v fastfetch &>/dev/null && fastfetch # If not in a git repo
fi

export PATH="$HOME/.local/bin:$PATH"

#!----------------------OS-SPECIFIC OVERRIDES------------------------!#
case "$(uname -s)" in
    Darwin)
        [[ -f "$HOME/.zshrc.macos" ]] && source "$HOME/.zshrc.macos"
        ;;
    Linux)
        [[ -f "$HOME/.zshrc.linux" ]] && source "$HOME/.zshrc.linux"
        ;;
esac

