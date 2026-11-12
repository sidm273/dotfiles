function fzfc --wraps='rg --color=always --line-number . | fzf --ansi' --description 'alias fzfc=rg --color=always --line-number . | fzf --ansi'
    rg --color=always --line-number . | fzf --ansi $argv
end
