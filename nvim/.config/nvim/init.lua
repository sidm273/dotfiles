--[[
 /\_/\  /\_/\  /\_/\
( o.o )( o.o )( o.o )
 > ^ <  > ^ <  > ^ <
--]]
--  NOTE: Vimsane must be called before plugins are loaded
require("debug.version")
require("core.vimsane")
require("core.keybinds")
require("core.lazy")
require("custom.filetypes")
require("custom.hacks")
--
-- Disable provider (and warning) for unused languages.
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
