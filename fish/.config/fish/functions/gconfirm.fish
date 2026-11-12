function gconfirm --wraps 'gum confirm' --description \
    "gum confirm wrapper"
    _set_dracula_colors
    gum confirm \
        --padding "1 2" \
        --prompt.foreground $purple \
        --prompt.background $bg \
        --selected.foreground $bg \
        --selected.background $green \
        --unselected.foreground $fg \
        --unselected.background $selection \
        $argv
end
