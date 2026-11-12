function gwarn --wraps 'gum log' --description \
    "gum log warning"
    glog --level warn $argv
end
