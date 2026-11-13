return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    -- blink is already installed.
    -- "saghen/blink.cmp",
  },
  config = function()
    require("minuet").setup({})
  end,
}
