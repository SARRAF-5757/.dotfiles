#config nu --doc | nu-highlight | less -R

if ($"($nu.home-path)/.config/oh-my-posh/bubbles.omp.json" | path exists) {
    oh-my-posh init nu --config ~/.config/oh-my-posh/bubbles.omp.json
}

$env.config.buffer_editor = "vim"
