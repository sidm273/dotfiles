function gerror --wraps 'gum log' --description \
    "gum log error"
    glog --level error $argv
end
