function mv --wraps='mv --interactive --verbose' --description 'alias mv=command mv --interactive --verbose'
    command mv --interactive --verbose $argv
end
# https://unix.stackexchange.com/questions/675018/fish-maximum-recursion-depth-reached-with-tab-complete
