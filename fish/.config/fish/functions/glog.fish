function glog --wraps 'gum log' --description \
    "gum log wrapper"
    _set_dracula_colors
    gum log \
        --level.background $bg \
        --prefix.background $bg \
        --time.background $bg \
        --time.foreground $yellow \
        $argv
    # --level.foreground $pink \
    # --prefix.foreground $pink \
    # --message.foreground $pink \
    # --message.background $bg \
    # --key.foreground $pink \
    # --key.background $bg \
    # --value.foreground $pink \
    # --value.background $bg \
    # --separator.foreground $pink \
    # --separator.background $bg \
end
