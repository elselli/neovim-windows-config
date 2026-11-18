-- C# language server via roslyn.nvim (Microsoft.CodeAnalysis.LanguageServer)

-- Map of repo folder name -> the only solution to use in that repo
local preferred_solution = {
  SpeedCarlsbergFalkenberg = "SpeedCarlsbergFalkenberg.slnx",
  SKFNordenMilano = "SKFNordenMilano.sln",
  ElseWareAGV = "ElseWareWCS.slnx",
}

---@type LazySpec
return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    init = function()
      -- Apply target options before roslyn.nvim's plugin/ file auto-starts the server
      require("roslyn").setup({
        choose_target = function(targets)
          if #targets == 0 then return nil end
          local repo = vim.fs.basename(vim.fs.dirname(targets[1]))
          local keep = preferred_solution[repo]
          if not keep then return nil end
          for _, target in ipairs(targets) do
            if vim.fs.basename(target) == keep then return target end
          end
          return nil
        end,
        ignore_target = function(target)
          local repo = vim.fs.basename(vim.fs.dirname(target))
          local keep = preferred_solution[repo]
          if not keep then
            return false -- no rule for this repo, don't filter
          end
          return vim.fs.basename(target) ~= keep
        end,
      })
    end,
    config = function()
      -- Keep roslyn.nvim's own "roslyn" auto-enable; only disable the duplicate lspconfig name
      vim.lsp.enable("roslyn_ls", false)
    end,
  },
  {
    -- Prevent AstroLSP/mason-lspconfig from also starting a server for C#.
    -- roslyn.nvim manages the server itself.
    "AstroNvim/astrolsp",
    opts = {
      handlers = {
        roslyn = false,
        roslyn_ls = false,
      },
    },
  },
}
