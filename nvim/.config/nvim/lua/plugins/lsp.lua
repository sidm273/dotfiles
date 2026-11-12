return {
  "neovim/nvim-lspconfig",
  config = function()
    local function lsp_enable(servers)
      for _, server in ipairs(servers) do
        local exe = server.exe or server.name
        if vim.fn.executable(exe) == 1 then
          -- vim.notify("Enabling LSP: " .. server.name, vim.log.levels.DEBUG)
          vim.lsp.enable(server.name)
        end
      end
    end
    lsp_enable({
      { name = "ty" },
      { name = "ruff" },
      { name = "fish_lsp", exe = "fish-lsp" },
      { name = "codebook" },
      { name = "tombi" },
      { name = "zizmor" },
      { name = "just" },
    })
  end,
}
