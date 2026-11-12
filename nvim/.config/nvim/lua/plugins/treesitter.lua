-- Tree-sitter support is built into Neovim
-- `:h treesitter`
-- `:h treesitter-query`
-- `:h text-objects`
-- `:h MiniAi.gen_spec.treesitter()`
-- `:checkhealth vim.treesitter nvim-treesitter` to see potential issues.
-- `:TSInstall <language>`

return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  -- Not techinically a dependency.
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  lazy = false,
  -- enabled = false,
  build = ":TSUpdate",
  branch = "main",
  -- NOT WORKING!!
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
  config = function()
    local ts = require("nvim-treesitter")
    -- ensure basic parser are installed
    -- Execute `:=require('nvim-treesitter').get_available()`
    local parsers = {
      "bash",
      "c",
      "comment",
      "commonlisp",
      "css",
      "csv",
      "diff",
      "dockerfile",
      "editorconfig",
      "fish",
      "git_config",
      "gitcommit",
      "gitignore",
      "gitattributes",
      "html",
      "json",
      "just",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "markdown_inline",
      "matlab",
      "powershell",
      "python",
      "regex",
      "scheme",
      "ssh_config",
      "todotxt",
      "toml",
      "tsv",
      "vhs",
      "vim",
      "vimdoc",
      "xresources",
      "yaml",
    }
    -- Added check to disable install in certain environments.
    if not os.getenv("ZID_ECORP") then
      for _, parser in ipairs(parsers) do
        ts.install(parser)
      end
    end

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
      -- check if parser exists and load it
      if not vim.treesitter.language.add(language) then
        return
      end
      -- enables syntax highlighting and other treesitter features
      vim.treesitter.start(buf, language)

      -- enables treesitter based folds
      -- for more info on folds see `:help folds`
      -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- vim.wo.foldmethod = 'expr'

      -- check if treesitter indentation is available for this language, and if so enable it
      -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
      local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

      -- enables treesitter based indentation
      if has_indent_query then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    local available_parsers = ts.get_available()
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end

        local installed_parsers = ts.get_installed("parsers")

        if vim.tbl_contains(installed_parsers, language) then
          -- enable the parser if it is installed
          treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
          -- require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
        else
          -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end,
}
