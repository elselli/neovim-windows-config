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

local saved_search = {}

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "*.log",
  callback = function()
    if saved_search.incsearch == nil then
      saved_search.incsearch = vim.o.incsearch
      saved_search.hlsearch = vim.o.hlsearch
      saved_search.shortmess = vim.o.shortmess
    end
    vim.o.incsearch = false
    vim.o.hlsearch = false
    vim.opt.shortmess:append("S")
    saved_search.statusline = saved_search.statusline or vim.o.statusline
    vim.o.statusline = "%f %m %=%l:%c"
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  pattern = "*.log",
  callback = function()
    if saved_search.incsearch == nil then return end
    vim.o.incsearch = saved_search.incsearch
    vim.o.hlsearch = saved_search.hlsearch
    vim.o.shortmess = saved_search.shortmess
    vim.o.statusline = saved_search.statusline
  end,
})
