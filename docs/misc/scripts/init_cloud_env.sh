#!/bin/sh
# Description: Initializes the cloud container environment.
# Exit on unhandled command failures and unset variable expansions.
set -o errexit -o nounset

# Setup dotfiles.
git clone https://github.com/sidm273/dotfiles "$HOME/dotfiles"
sh "$HOME/dotfiles/docs/misc/scripts/lnko_dl.sh"

cat >> "$HOME~/.bashrc" << 'EOF'

if [ -f ~/.bashrc.private ]; then
    . "$HOME/.bashrc.private"
fi
EOF

# Warning: this is a minimal setup and shell is not configured.
# Some configurations will not take effect.
cd "$HOME/dotfiles"
lnko link bash clanker git python scripts
# Setup GH_TOKEN to reference Custom Github Proxy PAT.
# echo 'export GH_TOKEN="$ZID_GH_PROXY_PAT"' >> ~/.bashrc
