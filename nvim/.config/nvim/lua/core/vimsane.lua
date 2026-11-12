-- `:help vim.opt`
-- `:help option-list`
-- Sane fucking defaults for neovim/vim.
-- Only change if things are not covered in mini.basics
-- or to taste.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
local opts = {
  -- Sane fucking cosmetics
  -- Make line numbers default
  relativenumber = true,
  -- Minimal number of screen lines to keep above and below the cursor.
  scrolloff = 10,
  -- Preview substitutions live, as you type!
  inccommand = "split",
  updatetime = 250,
  -- Displays which-key popup sooner
  timeoutlen = 300,
  -- All editing related settings are moved to editorconfig
  -- since multiple editors respect it and neovim enables it by default.
  -- Hence, following options are not set here.
  -- tabstop,textwidth,shiftwidth,softtabstop,expandtab
  wrap = true, -- explcitly set to avoid any overwrites.
  -- wrapmargin = 10, -- breaks 10 chars before textwidth
  -- Better to set it per file type.
  foldmethod = "manual",
}
-- vim.o is preffered over vim.opt due to easy access of values.
for opt, val in pairs(opts) do
  vim.o[opt] = val
end

vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
