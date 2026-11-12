function gspin --wraps 'gum spin' --description \
    "gum spin wrapper"
    _set_dracula_colors
    gum spin \
        --padding "1 2" \
        --spinner meter \
        --spinner.foreground $pink \
        --spinner.background $bg \
        --title.foreground $yellow \
        --title.background=$bg \
        $argv
end
