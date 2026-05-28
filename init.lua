require 'custom.keymaps'
require 'custom.basic_formatting'
require 'custom.asm_inspect'

vim.g.have_nerd_font = true

-- Load asm functions for c and cpp files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function()
    require 'custom.asm_inspect'
  end,
})

-- Install Lazy plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Configure and install plugins
require('lazy').setup({
  require 'custom.plugins.colors', -- load this first
  require 'custom.plugins.guess-indent',
  require 'custom.plugins.render-markdown',
  require 'custom.plugins.telescope',
  require 'custom.plugins.gitsigns',
  require 'custom.plugins.which-key',
  require 'custom.plugins.cmake-tools',
  require 'custom.plugins.lsp',
  require 'custom.plugins.which-key',
  require 'custom.plugins.todo-comments',
  require 'custom.plugins.treesitter',
  require 'custom.plugins.mini',
  require 'custom.plugins.smart-splits',
  require 'custom.plugins.noice',
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
