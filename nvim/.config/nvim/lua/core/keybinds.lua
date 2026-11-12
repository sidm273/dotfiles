-- [[Basic Keymaps]]
--  See `:help vim.keymap.set()`
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
--  Source: https://nvim-mini.org/MiniMax/configs/nvim-0.12/#plugin-20_keymaps.lua
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- Keybinds to make Buffer navigation easier
-- b is for 'Buffer'. Common usage:
vim.keymap.set("n", "gb", ":bprevious<CR>", { noremap = true, silent = true, desc = "Move to previous buffer" })
vim.keymap.set("n", "gn", ":bnext<CR>", { noremap = true, silent = true, desc = "Move to next buffer" })
vim.keymap.set("n", "<leader>ba", "<Cmd>b#<CR>", { desc = "Alternate" })
vim.keymap.set("n", "<leader>bd", "<Cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete" })
vim.keymap.set("n", "<leader>bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>", { desc = "Delete!" })
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end
vim.keymap.set("n", "<leader>bs", new_scratch_buffer, { desc = "Scratch" })
vim.keymap.set("n", "<leader>bf", "<Cmd>lua vim.api.nvim_clear_autocmds({group = 'Conform'})<CR>", { desc = "Live kill format-on-save" })
