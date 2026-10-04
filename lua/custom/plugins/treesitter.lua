return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath 'data' .. '/site', -- optional
    }

    -- Install parsers (replaces ensure_installed)
    require('nvim-treesitter').install {
      'bash',
      'c',
      'cpp',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'python',
      'json',
      'cmake',
      'matlab',
      'typescript',
      'javascript',
      'css',
      'scss',
      'svelte',
    }

    -- Treesitter-based indentation (replacement for the old `indent` module),
    -- with the same per-filetype disables as before
    local indent_disable = { ruby = true, c = true, cpp = true, dart = true }

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        if indent_disable[args.match] then
          return -- fall back to the default indentexpr
        end
        if pcall(vim.treesitter.start) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
