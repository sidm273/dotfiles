function cp --wraps='cp --interactive --verbose --recursive' --description 'alias cp=command cp --interactive --verbose --recursive'
    command cp --interactive --verbose --recursive $argv
end
# https://unix.stackexchange.com/questions/675018/fish-maximum-recursion-depth-reached-with-tab-complete
