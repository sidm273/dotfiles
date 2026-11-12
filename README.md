# dotfiles

A `$HOME` away from home.

## Instructions (For other humans)

- Welcome to my `$HOME`. This contains my personal set of _dotfiles_.
- All the content that is created by me is Licensed under MIT License.
- All the vendored content is usually cited and also contains the respective
  license.
- I use cuss words in code comments and docs without restraint. So, if you are a
  wimp, stop reading.

## Detailed instructions

All the instructions for humans and clankers are made available in
`clanker/.config/clanker/skills/dotfiles-helper/SKILL.md`. If set appropriately,
it should be autoloaded.

## Setup Notes

### Corporate remote setup

If your are in an organization with internal Gitlab/Bitbucket/Github, then after
configuring your SSH keys in the portal, to add the corporate remote do the
following.

- It will also disable accidental pushing to origin. (In addition to making PAT
  RO)

```bash
# strict mode
set -euo pipefail
# Set your corporate remote url here.
ecorp_remote="ecorp.forge.com"
git remote --verbose --tags add zid_ecorp "git@$ecorp_remote.git"
git remote set-url --push origin no-pushing
```

### Why Lnko?

lnko is a minimal stow alternative written in Lua and tiny enough to have a
standalone binary which can be vendored. Currently, it has issues with
symlinking on Windows. Eventually, I will either replace it with a minimal
shell/python script or get windows support working.

TODO: Consider splitting the current skill into multiple sub skills and scripts?
