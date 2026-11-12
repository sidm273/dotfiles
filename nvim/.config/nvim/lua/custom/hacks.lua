-- Some hacks to make neovim work with appimage
-- which has treesitter parsers bundled in.
-- vim.opt.runtimepath:append(vim.env.VIMRUNTIME .. '/../site')
if vim.env.APPDIR then
  -- inside the appimage
  vim.opt.runtimepath:append(vim.fs.dirname(vim.env.VIMRUNTIME) .. "/site")
end
