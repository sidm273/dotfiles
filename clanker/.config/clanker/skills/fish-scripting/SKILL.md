---
name: fish-scripting
description: >
    Conventions for writing shell scripts and functions in this environment.
    Fish over other shells, long-form options, preferred CLI tools, and syntax
    verification. Use whenever writing or modifying shell scripts.
---

# Fish Scripting

- Always prefer shell scripts to be written in `fish`.
- If user has not provided a location for the script, place them in the fish
  stow/lnko package: `fish/.local/bin/` for standalone executables on PATH, or
  `fish/.config/fish/functions/` for autoloaded functions.

## Coding style

- For shell commands and scripts always use long form options instead of short
  form. If a long form option does not exist, add a comment at the end of
  one-liners, or before the line in a script.
- Wherever possible, utilize fish shell builtins, unless performance is a
  concern. Example: only use ripgrep over `string match` if the user seems to be
  parsing a big file. Ask if you can't infer such a case.
- Utilize the following utils within shell scripts over any traditional
  alternatives. Format is new alternative > old option:
  - `rg` > `grep`; `bat` > `cat`; `dust` > `du`; `fd` > `find`; `just` > `make`;
    `ouch` > `zip`, `7z`, `tar`.
- Use `gum` and the corresponding helper functions `functions/g*.fish` if any
  interactivity is needed.
- Use `awk`, `tr`, `cut` only if absolutely necessary.
- If `fish-lsp` is available in path and you have the capability to utilize it,
  do so; if not, use `fish --no-execute` to check for basic syntax errors to
  correct. Never present code to the user without performing these checks.
- To obtain documentation for a new command, check whether a fish shell
  completion is available and use it; only run the command for help or read man
  pages if necessary.
