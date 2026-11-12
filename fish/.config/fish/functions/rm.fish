function rm --wraps='rm --recursive --verbose --interactive=once' --description 'alias rm=command rm --recursive --verbose --interactive=once'
    command rm --recursive --verbose --interactive=once $argv
end
# https://unix.stackexchange.com/questions/675018/fish-maximum-recursion-depth-reached-with-tab-complete
