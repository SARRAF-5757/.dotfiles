if status is-interactive
    # OMP Prompt Engine
    if command -v oh-my-posh > /dev/null
        if test -f ~/.config/oh-my-posh/bubbles.omp.json
            oh-my-posh init fish --config ~/.config/oh-my-posh/bubbles.omp.json | source
        else if test -f ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/bubbles.omp.json
            oh-my-posh init fish --config ~/.dotfiles/common/oh-my-posh/.config/oh-my-posh/bubbles.omp.json | source
        end
    end

    # Fish prompt
    # function fish_prompt
    #     set -g fish_transient_prompt 1
    #     printf '%s@%s %s%s%s > ' $USER $hostname \
    #         (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    # end
    # function fish_right_prompt -d "Write out the right prompt"
    #     date '+%m/%d/%y'
    # end

    # Keybind

    # Aliases
    abbr --add ls eza --width 70 --no-quotes --icons=always --color=always -a
    abbr --add tree eza -T --total-size --no-quotes --icons=always --color=always
    abbr --add cd z
    abbr --add cls clear
    abbr --add gits git status
    abbr --add gitr git remote show origin
    abbr --add avim='NVIM_APPNAME="nvim-astronvim" nvim'
    abbr --add vim='NVIM_APPNAME="nvim-lazyvim" nvim'
    abbr --add chvim='NVIM_APPNAME="nvim-nvchad" nvim'
    abbr --add kvim='NVIM_APPNAME="nvim-kickstart" nvim'
end


# User local bin path
fish_add_path -g $HOME/.local/bin

