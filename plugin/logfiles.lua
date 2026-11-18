-- Make large *.log files cheap to open and scroll
local group = vim.api.nvim_create_augroup("LogFilePerf", { clear = true })

vim.api.nvim_create_autocmd("BufReadPre", {
  group = group,
  pattern = "*.log",
  callback = function()
    vim.opt_local.swapfile = false
    vim.opt_local.undofile = false
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.wrap = false
    vim.opt_local.synmaxcol = 200
    vim.opt_local.spell = false
    vim.opt_local.list = false
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "*.log",
  callback = function(args)
    vim.bo[args.buf].syntax = "off"
    pcall(vim.treesitter.stop, args.buf)
  end,
})
