function gchoose --wraps 'gum choose' --description \
    "gum choose wrapper"
    _set_dracula_colors
    gum choose \
        --padding "1 2" \
        --cursor.foreground $pink \
        --cursor.background $bg \
        --header.foreground $purple \
        --header.background $bg \
        --item.foreground $fg \
        --item.background $bg \
        --selected.foreground $green \
        --selected.background $bg \
        $argv
end

# TODO: https://github.com/charmbracelet/gum/pull/1058/changes/98173937ebdbf7bae67e015bf2fa435579894147
