#Enable Powerlevel10k instant prompt.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

#!------------------------------VARIABLES------------------------------!#
export ZSH="$HOME/.oh-my-zsh" # Path to Oh My Zsh installation

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

#!------------------------------ZSH THEME------------------------------!#
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME=""


#!-----------------------------LOAD PLUGINS-----------------------------!#
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    macos
    git
    vscode
    eza
    zoxide
    brew
    colored-man-pages
    colorize
    thefuck
    themes
)

#!-----------------------------ZSH OPTIONS-----------------------------!#
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
#COMPLETION_WAITING_DOTS="%F{red}waiting...%f"   # display red dots whilst waiting for completion
# DISABLE_UNTRACKED_FILES_DIRTY="true"  # disable marking untracked files under VCS as dirty
#HIST_STAMPS="mm/dd/yyyy"                # change time stamp format in the history command output
# ZSH_CUSTOM=/path/to/new-custom-folder # if using custom folder than $ZSH/custom


#!---------------------------CONFIGURE PLUGINS---------------------------!#
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#3e3e3e,bold"
ZSH_AUTOSUGGEST_STRATEGY=(completion match_prev_cmd)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybinds
bindkey '^I' autosuggest-accept
bindkey '\e\x7F' backward-kill-word
bindkey '\ew' backward-kill-line
bindkey \^U backward-kill-line

# Aliases
alias tree='eza -T --total-size --no-quotes --icons=always --color=always'
alias ls='eza --width 70 --no-quotes --icons=always --color=always -a'
alias lss='eza -l --icons=always --total-size --git --no-user --no-permissions --no-time'
alias cat='bat'
alias cd='z'
alias cls='clear'
alias gits='git status'
alias gitr='git remote show origin'
# Multi-distro neovim setup
alias avim='NVIM_APPNAME="nvim-astronvim" nvim'
alias vim='NVIM_APPNAME="nvim-lazyvim" nvim'
alias chvim='NVIM_APPNAME="nvim-nvchad" nvim'
alias kvim='NVIM_APPNAME="nvim-kickstart" nvim'

# Functions
function title() {          # Customize tab titles
    echo -en "\e]2;$@\a"
}

export EDITOR="vim"
function y() {              # Yazi Setup
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# Oh My Posh
#eval "$(oh-my-posh init zsh --config ~/Coding/Personal/OMP-Wizard/build/temp.omp.json --trace)"
#eval "$(oh-my-posh init zsh --config ~/Coding/Personal/OMP-Wizard/build/test.omp.json --trace)"

eval "$(oh-my-posh init zsh --config ~/.dotfiles/OMP-themes/mytheme.omp.json --trace)"
#eval "$(oh-my-posh init zsh --config ~/.dotfiles/OMP-themes/nightowl.omp.json --trace)"
#eval "$(oh-my-posh init zsh --config ~/.dotfiles/OMP-themes/atomic.omp.json --trace)"
#eval "$(oh-my-posh init zsh --config ~/.dotfiles/OMP-themes/bubbles.omp.json --trace)"
#eval "$(oh-my-posh init zsh --config ~/.dotfiles/OMP-themes/chips.omp.json --trace)"
