set shell := ["fish", "-c"]

# Uncomment the following to use a backup shell till you are setup with fish
# set shell := ["bash", "-c"]

pkgs := "bash bat brew clanker eza fish fzf git nvim python ripgrep scripts starship yazi"

default:
    just --choose

status:
    # Show the status of links.
    lnko status

link:
    # Setup Home environment by unlinking and then relinking.
    # without args lnko links packages from current directory to $HOME
    lnko unlink {{ pkgs }} && lnko link {{ pkgs }} && lnko status

depart:
    # Depart Home environment by unlinking.
    lnko unlink {{ pkgs }} && lnko status
