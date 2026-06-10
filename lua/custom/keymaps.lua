--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostics
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Get man pages if exist
vim.keymap.set('n', '<leader>m', function()
  local word = vim.fn.expand '<cword>'
  local ok, _ = pcall(vim.cmd, 'horizontal Man ' .. word)
  if not ok then
    print('No man page available: ' .. word)
  end
end, { desc = 'Open man pages' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Moving blocks of text
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

-- Moving single line
vim.keymap.set('n', '<A-j>', ':m.+1<CR>')
vim.keymap.set('n', '<A-k>', ':m.-2<CR>')

-- Splits
vim.keymap.set('n', '<leader>-', ':spl<CR>', { desc = 'Split horizontally' })
vim.keymap.set('n', '<leader>|', ':vsp<CR>', { desc = 'Split vertically' })

-- Open netrw
vim.keymap.set('n', '<Tab>', ':e .<CR>', { desc = 'Open NetRW in project root' })
vim.keymap.set('n', '-', ':Ex<CR>', { desc = 'Open NetRW in current file dir' })

-- Copy and paste to system
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
