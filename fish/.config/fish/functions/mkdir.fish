function mkdir --wraps='mkdir --parents --verbose' --description 'alias mkdir=command mkdir --parents --verbose'
    command mkdir --parents --verbose $argv
end
# https://unix.stackexchange.com/questions/675018/fish-maximum-recursion-depth-reached-with-tab-complete
