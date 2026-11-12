return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        css = { "prettier" },
        js = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        just = { "just" },
        toml = { "tombi" },
        python = {
          -- To fix auto-fixable lint errors.
          "ruff_fix",
          -- To run the Ruff formatter.
          "ruff_format",
          -- To organize the imports.
          "ruff_organize_imports",
        },
        -- Conform will run the first available formatter
        markdown = {
          -- Rust based
          "rumdl",
          -- Commonmark spec formatter
          "mdformat",
          -- Backup default.
          "prettier",
          stop_after_first = true,
        },
        sh = {
          "shfmt",
          "beautysh",
          stop_after_first = true,
        },
      },
      format_on_save = {
        timeout_ms = 500,
      },
      -- Added to stop notifications.
      notify_no_formatters = false,
    })
  end,
}
