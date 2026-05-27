return {
  'ellisonleao/gruvbox.nvim',
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  config = function()
    require('gruvbox').setup {
      -- Your config here
    }
    vim.cmd.colorscheme 'gruvbox'
  end,
}
