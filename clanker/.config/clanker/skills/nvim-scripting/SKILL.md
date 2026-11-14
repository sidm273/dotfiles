---
name: nvim-scripting
description: >
  Conventions for configuring Neovim — Lua-first config, mini.nvim for
  language-agnostic features, lazy.nvim as package manager, MiniMax as
  reference config. Use when writing or reviewing Neovim config, keymaps, or
  plugin setup.
---

# Nvim Scripting

- Use and recommend only Lua code for configuring Neovim.
- If configuring using the Lua `vim` API is not possible, only then recommend
  the legacy vimscript way.
- Leverage existing plugins, especially the `mini.nvim` plugin set, for features
  that are language-agnostic.
- `lazy.nvim` is the package manager of choice; check `lazy-lock.json` for
  available plugins.
- If the user asks for a keymap, search both custom keymaps and plugin defaults
  before answering.
- Before answering how a plugin's API/mechanism works (commands, autocmds,
  config options), read the actual installed source under
  `~/.local/share/nvim/lazy/<plugin>/` (or its `doc/`) instead of answering from
  training-data memory of the plugin. Plugin APIs change across versions and
  READMEs can lag the code.
- If the user asks for a reference config or how to achieve something, check
  whether [MiniMax](https://nvim-mini.org/MiniMax/index.html) already does it
  and suggest integrating that.
- User prefers using builtin functionality and/or leveraging existing plugins
  instead of adding newer plugins (if possible). An external plugin has to earn
  it's place.
