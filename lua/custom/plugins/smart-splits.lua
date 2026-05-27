return { -- Smart splits with Kitty
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  keys = {
    {
      '<C-h>',
      function()
        require('smart-splits').move_cursor_left()
      end,
    },
    {
      '<C-j>',
      function()
        require('smart-splits').move_cursor_down()
      end,
    },
    {
      '<C-k>',
      function()
        require('smart-splits').move_cursor_up()
      end,
    },
    {
      '<C-l>',
      function()
        require('smart-splits').move_cursor_right()
      end,
    },
  },
  build = './kitty/install-kittens.bash',
  opts = {
    multiplexer_integration = 'kitty',
    at_edge = 'stop',
  },
}
