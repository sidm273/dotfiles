#!/bin/fish
fish_config theme choose "Dracula Official"
# disable greeting message.
set --global fish_greeting
########################################
#        Environment Variables         #
########################################
## XDG Specification.
set --global --export XDG_CONFIG_HOME $HOME/.config
set --global --export XDG_CACHE_HOME $HOME/.cache
set --global --export XDG_DATA_HOME $HOME/.local/share
set --global --export XDG_STATE_HOME $HOME/.local/state
## Set the editor
set --global --export EDITOR nvim
# add binaries to path
fish_add_path --global $HOME/.local/bin
# add manpages to path
set --global --export MANPATH $MANPATH $HOME/.local/share/man
# use bat as manpager
# Broken currently: See https://github.com/sharkdp/bat/issues/3724
# set --global --export MANPAGER 'bat --plain --language man'
# temporary workaround
set --global --export MANPAGER "sh -c 'col --no-backspaces --spaces | bat --language man --plain'"
set --global --export MANROFFOPT -c
# Personal settings.
# Set dotfiles path.
set --global --export ZID_DOT $HOME/dotfiles
########################################
#    Tool related Settings to Load     #
########################################
# Test if inside a corporate environment
if set --query ZID_ECORP
    # Mostly in corporate environment
    # unfuck keys when using VNC/SSH
    # to debug use the command
    # fish_key_reader --verbose
    bind \x7f backward-delete-char
    bind \e\[3~ delete-char
    # fractional scaling setting for virtuoso
    set --global --export QT_SCALE_FACTOR 1.5
    # to disable SOS GUI popping up on startup
    set --global --export CSD_NO_SOS_GUI
    # to disable the SOS popup that gates exit from virtuoso
    set --global --export SOS_CDS_EXIT yes
    # set language correctly since it might be fucked up.
    set --global --export LANG en_US.UTF-8
else
    # At home.
    # Initialize Homebrew related stuff first since it adds paths.
    # Absolute prefix path needed here.
    if test -x /home/linuxbrew/.linuxbrew/bin/brew # isE(x)ecutable?
        /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source
        set --global --export HOMEBREW_BUNDLE_FILE $HOME/.config/brew/personal_brew_file.rb
        if test -d (brew --prefix)"/share/fish/completions" # is(d)irectory?
            set -p fish_complete_path (brew --prefix)/share/fish/completions
        end
        if test -d (brew --prefix)"/share/fish/vendor_completions.d" # is(d)irectory?
            set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
    end
    set --global --export ZID_EFILES $HOME/files
    set --global --export ZID_OFILES $HOME/open_files
end
abbr --add --position anywhere -- --help '--help | bat -plhelp'
# abbr --add --position anywhere -- -h '-h | bat -plhelp' # too irritating!
set --global --export RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/.ripgreprc
set --global --export FZF_DEFAULT_OPTS_FILE $XDG_CONFIG_HOME/fzf/.fzfrc
set --global --export PYTHONSTARTUP $XDG_CONFIG_HOME/ptpython/pythonstartup.py
# eza theme file requires this to be unset to take effect.
set --erase LS_COLORS
# keybindings source
# set --global fish_key_bindings fish_vi_key_bindings
# fzf.fish specific settings.
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set fzf_preview_dir_cmd eza --all --color=always
zoxide init fish --cmd cd | source
# Nothing after starship line.
starship init fish | source
# Nothing below this line.
