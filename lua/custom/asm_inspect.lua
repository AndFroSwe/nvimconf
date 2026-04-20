local M = {}

local dump_asm = function(opt_level)
  -- create raw assembly
  local file = vim.fn.expand '%:p'
  local compiler = 'clang'
  local flags = '-S -g -fverbose-asm'
  local cmd = compiler .. ' ' .. file .. ' ' .. flags .. ' -' .. opt_level .. ' -o - | llvm-cxxfilt'

  local output = vim.fn.systemlist(cmd) -- try compile

  -- create in an anonymous buffer
  vim.cmd 'vnew'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false -- clean source file

  -- clean file
  vim.cmd [[%s#\v/[^ \t\n:]+#\=luaeval('vim.fs.normalize(_A)', submatch(0))#ge]] -- normalize paths
  vim.cmd 'set syntax=asm' -- get nice highlighting
  vim.cmd '%g/#DEBUG_/d' -- remove dwarf comments
  vim.cmd '%g/.Ltmp/d' -- remove dwarf block annotations
end

-- map functions
vim.keymap.set('n', '<leader>ad0', function()
  dump_asm 'O0'
end, { desc = 'Dump assembly [-O0]' })

vim.keymap.set('n', '<leader>ad1', function()
  dump_asm 'O1'
end, { desc = 'Dump assembly [-O1]' })

vim.keymap.set('n', '<leader>ad2', function()
  dump_asm 'O2'
end, { desc = 'Dump assembly [-O2]' })

vim.keymap.set('n', '<leader>ad3', function()
  dump_asm 'O3'
end, { desc = 'Dump assembly [-O3]' })

return M
