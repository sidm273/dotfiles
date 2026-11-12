function lsd --wraps='eza --almost-all --group-directories-first --long --only-dirs' --description 'alias lsd=eza --almost-all --group-directories-first --long --only-dirs'
    eza --almost-all --group-directories-first --long --only-dirs $argv
end
