function cat --wraps='bat' --description 'alias cat=bat'
    if command -q bat
        # needed since fish needs actual cat for loading initial config
        bat $argv
    else
        command cat $argv
    end
end