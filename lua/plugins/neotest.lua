-- Run .NET unit tests from Neovim via neotest + neotest-dotnet (wraps `dotnet test`)

---@type LazySpec
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "Issafalcon/neotest-dotnet",
    },
    cmd = { "Neotest" },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test all" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
      { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Test output panel" },
      { "<leader>tx", function() require("neotest").run.stop() end, desc = "Test stop" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dotnet")({
            -- "project" = discover per .csproj, "solution" = per .sln/.slnx, "dir" = per directory
            discovery_root = "project",
          }),
        },
      })
    end,
  },
}
