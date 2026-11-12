function gfatal --wraps 'gum log' --description \
    "gum log fatal"
    glog --level fatal $argv
end
