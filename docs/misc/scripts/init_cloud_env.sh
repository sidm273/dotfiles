#!/bin/sh
# Description: Initializes the cloud container environment.
# Exit on unhandled command failures and unset variable expansions.
set -o errexit -o nounset
# Setup GH_TOKEN to reference Custom Github Proxy PAT.
export GH_TOKEN="$ZID_GH_PROXY_PAT"
# Setup dotfiles.
gh repo clone sidm273/dotfiles "$HOME/dotfiles"
sh "$HOME/dotfiles/docs/misc/scripts/lnko_dl.sh"
export PATH="$HOME/.local/bin:$PATH"
cd "$HOME/dotfiles"
# Warning: this is a minimal setup and shell is not configured.
# Some configurations will not take effect.
lnko link clanker git python scripts
