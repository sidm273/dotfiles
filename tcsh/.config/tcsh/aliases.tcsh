#!/usr/bin/env tcsh
# idiom: if the file exists then source it.
# if ( -e <filepath>) source <filepath>
########################################
alias cat 'bat'
alias grep 'rg'
alias find 'fd'
alias du 'dust'
alias l 'eza --almost-all --group-directories-first --grid'
# --icons auto is needed not a bug.
alias ll 'eza --almost-all --group-directories-first --long --icons auto'
alias ls 'eza --almost-all --group-directories-first --long --icons auto'
alias lsd 'eza --almost-all --group-directories-first --long --only-dirs'
alias rm 'rm --recursive --verbose --interactive=once'
alias cp 'cp --interactive --verbose'
alias cpx 'rsync --archive --verbose --progress'
alias mv 'mv --interactive --verbose'
alias mkdir 'mkdir --parents --verbose'
# vim4life
alias vi 'nvim'
alias vim 'nvim'
alias n 'nvim'
alias f 'fish'
# Fuzzy finding
alias fzfc 'rg --color=always --line-number . | fzf --ansi'
# just command runner
alias j 'just'
alias x 'exit'
# custom functions implemented as aliases
if ( -e $XDG_CONFIG_HOME/tcsh/yazi.tcsh ) source $XDG_CONFIG_HOME/tcsh/yazi.tcsh
# RESERVED, PLEASE DON'T USE THE FOLLOWING ALIASES ELSEWHERE.
# a, s, d ...
