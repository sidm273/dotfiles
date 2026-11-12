return {
  "nvim-mini/mini.nvim",
  version = false, -- main (recommended) branch.
  dependencies = {
    "https://github.com/rafamadriz/friendly-snippets",
  },
  config = function()
    require("mini.ai").setup({ n_lines = 500 })
    require("mini.surround").setup()
    require("mini.pairs").setup({
      mappings = {
        ["'"] = false,
        ["`"] = false,
      },
    })
    require("mini.diff").setup()
    require("mini.bufremove").setup()
    require("mini.sessions").setup({
      config = {
        -- Whether to read default session if Neovim opened without file arguments
        autoread = true,
      },
    })
    local gen_loader = require("mini.snippets").gen_loader
    require("mini.snippets").setup({
      snippets = {
        gen_loader.from_lang(),
      },
    })
    -- Indentscope is not used since it only does scope and
    -- not the entire file.
    -- require('mini.indentscope').gen_animation.none()
    local comments = require("mini.comment")
    local hipatterns = require("mini.hipatterns")
    local statusline = require("mini.statusline")
    local basics = require("mini.basics")
    basics.setup({
      options = {
        basic = true,
        extra_ui = true,
      },
      mappings = {
        basic = false,
        windows = true,
      },
    })
    hipatterns.setup({
      highlighters = {
        -- Highlight standalone 'PORTME' 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        portme = { pattern = "%f[%w]()PORTME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
    comments.setup({
      mappings = {
        comment = "gc",
        comment_line = "gc",
        comment_visual = "gc",
        textobject = "gc",
      },
    })
    statusline.setup({ use_icons = vim.g.have_nerd_font })
    statusline.section_location = function()
      return "%2l:%-2v"
    end
  end,
}
