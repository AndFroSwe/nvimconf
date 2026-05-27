-- Basic formatting
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smarttab = true
vim.o.tabstop = 2

-- Use line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Only set textwidth for files with no natural line break
local column_count = 120
vim.o.colorcolumn = tostring(column_count)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'text', 'markdown' },
  callback = function()
    vim.opt_local.textwidth = column_count
  end,
})

-- Performance
vim.o.updatetime = 500 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Display whitespace and tabs
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Misc
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true -- Save undo history
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.inccommand = 'split' -- Preview substitutions
vim.o.cursorline = true
vim.o.scrolloff = 10 -- Screen line margin from cursor
vim.o.confirm = true

-- Clipboard
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
