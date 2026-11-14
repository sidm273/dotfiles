---
name: dotfiles-helper
description: >
    Repository-specific help for the user's ~/dotfiles checkout: lnko/stow
    package linking, this repository's just recipes, its first-time setup, and
    its XDG compliant layout. Trigger only when the task explicitly concerns ~/dotfiles
    or the current repository is confirmed to be ~/dotfiles. Do not use for
    general repository structure, other dotfiles repositories, or generic
    Linux and sysadmin questions.
license: MIT
metadata:
  author: Sid L
  scope: "~/dotfiles only"
  tags:
    - dotfiles
    - linux
    - sysadmin
compatibility: Requires just, either stow/lnko or similar program in user's `PATH`.
---

# dotfiles-helper

## Conventions

- All paths assume the `dotfiles` repository as the current working directory.
- The word **just** refers to the `just` task runner.
- This repository strongly follows
  [XDG Base Directory Specification](https://wiki.archlinux.org/title/XDG_Base_Directory)
- Respect user, directory, sub-directory level `.gitignore`.

## Prerequisites

- `just`, `lnko`/`stow` must be available in the user's `PATH`.
- **ALWAYS** use `--dry-run` option for linking, and provide the user this
  command to run it by themselves instructing them to remove the `--dry-run`
  option.

## Key locations

This repo is structured to be used with a symlink farm manager.

- Agent skills: `clanker/.config/clanker/skills/`.
- Agent skills offline references:
  `clanker/.config/clanker/skills/*/references/`.
- `docs/misc/scripts`: One off scripts.
- Personal project repositories: if `gh_repos` exists as a symlink, that is
  where personal project repositories live.

## Setup

The bootstrap examples use Bash because fish may not be installed yet on a new
machine.

### First time setup (Manual download)

Currently, this script is a rough draft. Hence, help the user with their
specific setup and walk them through how a symlink farm manager works.

```bash
# Assuming you have downloaded the `dotfiles.tar.gz` to your `~/Downloads` directory.
# Download and extract the source code.
tar --extract --gzip --verbose --file ~/Downloads/dotfiles.tar.gz
# go to the directory you extracted. or move the extracted
# to the ~/dotfiles and cd into it.
cd ~/dotfiles
export PATH="$PATH:$HOME/dotfiles/docs/bin"
# Replace package-name with a package directory from this repository.
lnko link --target $HOME --dry-run --verbose nvim brew fish git package-name wezterm
lnko status
```

### First time setup (Automated download)

- Prerequisites: `gh` and `git` available in the user's `PATH`.
- You need to configure a
  [PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)
  for your repository with the following settings.
  - Set expiry to 30 days.
  - Set RO access to only this repository contents.

```bash
# DEMO script only. Needs to be modified for specific use case.
# strict mode
set -euo pipefail
# Set github_username
gh_uname="<your_github_username>"
cd $HOME
# The following will ask for PAT
gh auth login --git-protocol https --hostname github.com
# For clone
gh repo clone "$gh_uname/dotfiles"
# For pull uncomment the following.
# cd ~/dotfiles
# git pull origin main
# For downloading releases
gh release --repo "$gh_uname/dotfiles" list
# To get the latest release tag name.
tag_name=$(gh release list --repo "$gh_uname/dotfiles" \
    --json tagName,isLatest \
    --jq '.[] | select(.isLatest) | .tagName')
mkdir binaries
gh release --repo "$gh_uname/dotfiles" download "$tag_name" --dir ./binaries
# Logout after usage.
gh auth logout --user "$gh_uname"
```

## Basic lnko usage

```bash
lnko --help
# Remove orphan symlinks
lnko clean
```

### Agent skills

- Inform the user if the agent's default directory for preloading skills is not
  symlinked to this directory.
- `lnko link clanker` links the Clanker configuration and skills.

## Scripts

All the key scripts are `just` recipes.

If any command needs to be run more than once help user creating and documenting
it as a just recipe using the relevant skills.

### Post Setup

- Certain packages require additional setup on newer machines, eg: build cache,
  merge resources etc. Each package has its own header to indicate the package
  to be linked before running the configuration commands and might require
  re-linking.
- See `docs/misc/justfile`

## References

- [stow](https://www.gnu.org/software/stow/).
- [lnko](https://github.com/luanvil/lnko)
