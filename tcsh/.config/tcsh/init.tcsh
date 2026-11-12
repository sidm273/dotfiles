#!/usr/bin/env tcsh
# idiom: if the file exists then source it.
# if ( -e <filepath>) source <filepath>
# XDG Specification.
# setenv XDG_CONFIG_HOME $HOME/.config # Defined in ~/.cshrc.private
setenv XDG_CACHE_HOME $HOME/.cache
setenv XDG_DATA_HOME $HOME/.local/share
setenv XDG_STATE_HOME $HOME/.local/state
# Don't set XDG_RUNTIME_DIR! It should be set by pam_systemd
# fractional scaling setting for virtuoso
setenv QT_SCALE_FACTOR 1.5
# to disable SOS GUI popping up on startup
setenv CSD_NO_SOS_GUI
# to disable the SOS popup that gates exit from virtuoso
setenv SOS_CDS_EXIT yes
# Set the editor
setenv EDITOR nvim
# Loading the custom binaries.
setenv PATH $PATH\:$HOME/.local/bin
# Loading the custom man pages.
setenv MANPATH $MANPATH\:$HOME/.local/share/man
# use bat as manpager
setenv MANPAGER "bat --plain --language man"
# Set dotfiles path.
setenv ZID_DOT $HOME/dotfiles
# custom tool env vars.
setenv RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/.ripgreprc
setenv FZF_DEFAULT_OPTS_FILE $XDG_CONFIG_HOME/fzf/.fzfrc
# eza theme file requires this to be unset to take effect.
unsetenv LS_COLORS
# sourcery
if ( -e $XDG_CONFIG_HOME/tcsh/key_unfuck.tcsh ) source $XDG_CONFIG_HOME/tcsh/key_unfuck.tcsh
# Set a path for Corporate scripts to be loaded.
setenv ZID_ECORP $HOME/zid_ecorp
if ( -e $ZID_ECORP/tcsh/init.tcsh ) source $ZID_ECORP/tcsh/init.tcsh
# Load aliases eventually.
if ( -e $XDG_CONFIG_HOME/tcsh/aliases.tcsh ) source $XDG_CONFIG_HOME/tcsh/aliases.tcsh
# only if csh -> tcsh
# zoxide disabled for now
# zoxide init tcsh --cmd cd > ~/.zoxide.tcsh
# source ~/.zoxide.tcsh
# Must be last line.
eval `starship init tcsh`
