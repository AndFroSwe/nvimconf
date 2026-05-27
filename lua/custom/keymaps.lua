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
