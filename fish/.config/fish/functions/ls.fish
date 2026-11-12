function ls --wraps='eza --almost-all --group-directories-first --long --icons auto' --description 'alias ls=eza --almost-all --group-directories-first --long --icons auto'
    eza --almost-all --group-directories-first --long --icons auto $argv
end
