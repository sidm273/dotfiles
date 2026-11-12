---------------------------------------
-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local config = wezterm.config_builder()
---------------------------------------
-- Custom configuration goes below
-- Window/Tab settings
config.window_decorations = "TITLE | RESIZE"
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
-- Colors
config.color_scheme = "Dracula (Official)"
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = 16
-- Shell related
-- TODO: Update for new Powershell version.
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe", "-NoLogo" }
end
-- Finally, return the configuration to wezterm:
return config
