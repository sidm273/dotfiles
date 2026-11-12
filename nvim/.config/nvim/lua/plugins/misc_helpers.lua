return {
  dir = vim.fn.stdpath("config") .. "/plugins/float-help.nvim",
  config = function()
    require("float-help").setup()
  end,
}
