function cpx --wraps='rsync --archive --verbose --progress' --description 'alias cpx=rsync --archive --verbose --progress'
    rsync --archive --verbose --progress $argv
end
