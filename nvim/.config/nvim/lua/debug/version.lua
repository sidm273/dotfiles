local required = "0.12.5" -- Minimum allowed version.
if vim.fn.has("nvim-" .. required) ~= 1 then
  vim.notify(string.format("Expected nvim %s, got %s", required, tostring(vim.version())), vim.log.levels.ERROR)
end
