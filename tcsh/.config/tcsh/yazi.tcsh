#!/usr/bin/env tcsh
# wrapper for yazi.
# y to start yazi with memory,
# q to Quit in yazi CWD
# Q to without changing launch dir
# y - yazi wrapper with directory memory
# hints:
#  \!*  argument selector for all arguments, excluding the alias/command;
#       arguments need not be supplied.
# retarted tcsh needs it on single line.
alias y 'set tmp = `mktemp -t "yazi-cwd.XXXXXX"` ; yazi \!* --cwd-file="$tmp" ; if ( -f "$tmp" ) then ; set cwd = `cat "$tmp"` ; if ( "$cwd" != "`pwd`" && -d "$cwd" ) chdir "$cwd" ; rm -f -- "$tmp" ; endif'
