# Enable Powerlevel10k instant prompt.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

export ZSH="$HOME/.oh-my-zsh" #Path to Oh My Zsh installation

#!------------------------------ZSH THEME------------------------------!#
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    #ZSH_THEME="powerlevel10k/powerlevel10k"
    eval "$(oh-my-posh init zsh --config .mytheme.omp.yaml)"
fi


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
COMPLETION_WAITING_DOTS="%F{red}waiting...%f"   # display red dots whilst waiting for completion
# DISABLE_UNTRACKED_FILES_DIRTY="true"  # disable marking untracked files under VCS as dirty
HIST_STAMPS="mm/dd/yyyy"                # change time stamp format in the history command output
# ZSH_CUSTOM=/path/to/new-custom-folder # if using custom folder than $ZSH/custom


#!-----------------------------LOAD PLUGINS-----------------------------!#
plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-tab-title
    macos
    git
    vscode
    eza
    zoxide
)

#!---------------------------CONFIGURE PLUGINS---------------------------!#
ZSH_TAB_TITLE_ONLY_FOLDER=true

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Aliases
alias tree='eza -T --total-size --no-quotes --icons=always --color=always'
alias ls='eza --width 70 --no-quotes --icons=always --color=always -a'
alias lls='eza -l --icons=always --total-size --git --no-user --no-permissions --no-time'
alias cat='bat'
alias cd='z'
alias gits='git status'
alias gitr='git remote show origin'

# Keybinds
bindkey '^I' autosuggest-accept

# Functions
function title() {         # Customize tab titles
    echo -en "\e]2;$@\a"
}

gitac() {
    git add -A
    git commit -m "$1"
}


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi
