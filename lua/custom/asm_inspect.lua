local dump_asm = function(opt_level)
  -- create raw assembly
  local file = vim.fn.expand '%:p' -- get the current file
  local compiler = 'clang'
  local flags = '-S -g -fverbose-asm' -- minimal flags to inject
  local cmd = '' -- compile command

  -- check if there is a compile_commands.json
  local compile_commands = vim.fn.getcwd() .. '/compile_commands.json'
  if vim.fn.filereadable(compile_commands) == 1 then
    -- found compile_commands.json
    vim.notify('Found compile commands!', vim.log.levels.INFO)
    local content = table.concat(vim.fn.readfile(compile_commands), '\n')
    local db = vim.json.decode(content)

    -- find entry in compile db
    local entry = nil
    for _, e in ipairs(db) do
      if e.file == file then
        entry = e
        break
      end
    end

    -- extract includes
    if entry ~= nil then
      -- found entry, fix it and use it
      local cmd_raw = entry.command

      -- Remove existing optimization flags (-O0, -O1, -O2, -O3, -Og, -Os, -Ofast)
      cmd_raw = cmd_raw:gsub('%s*%-O%w*', '')

      -- Remove existing -g flags (to avoid duplicates)
      cmd_raw = cmd_raw:gsub('%s*%-g%d?', '')

      -- Remove existing -S flags
      cmd_raw = cmd_raw:gsub('%s*%-S(%s)', '%1')
      cmd_raw = cmd_raw:gsub('%s*%-S$', '')

      -- remove -o so it can be replaced with stdout
      cmd_raw = cmd_raw:gsub('%s+%-o%s*%S+', ' -o -')

      -- remove -c
      cmd_raw = cmd_raw:gsub('%s+%-c(%s)', '%1')
      cmd_raw = cmd_raw:gsub('%s+%-c$', '')

      -- Strip GCC-specific flags that clang doesn't understand
      cmd_raw = cmd_raw:gsub('%s*%-fmodules%-ts', '')
      cmd_raw = cmd_raw:gsub('%s*%-fmodule%-mapper=%S+', '')
      cmd_raw = cmd_raw:gsub('%s*%-fdeps%-format=%S+', '')
      cmd_raw = cmd_raw:gsub('%s*%-MD', '')

      -- Inject -g, -S, and your optimization level after the compiler binary
      cmd = cmd_raw:gsub('^(%S+)', compiler .. ' ' .. flags .. ' -' .. opt_level)
    else
      -- didnt find entry in compile db
      vim.notify('Could not find file ' .. file .. ' in compile_commands.json!', vim.log.levels.DEBUG)
      cmd = compiler .. ' ' .. file .. ' ' .. flags .. ' -' .. opt_level .. ' -o -'
    end
  else
    -- there was no compile commands, set simple compilation manually
    vim.notify('Found compile no commands, trying to compile anyway...', vim.log.levels.INFO)
    cmd = compiler .. ' ' .. file .. ' ' .. flags .. ' -' .. opt_level .. ' -o -'
  end

  -- try compile
  print(cmd)
  local output = vim.fn.systemlist(cmd)

  -- check for errors
  if vim.v.shell_error ~= 0 then
    vim.notify(table.concat(output, '\n'), vim.log.levels.ERROR)
    return
  end

  -- ok, first demangle
  output = vim.fn.systemlist('llvm-cxxfilt', table.concat(output, '\n'))

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
