return {
  cond = not vim.g.vscode,
  'mfussenegger/nvim-dap',

  config = function()
    local dap = require('dap')
    local widgets = require('dap.ui.widgets')
    local repl = require('dap.repl')
    local ui = require('dap.ui')
    local dap_vs = require('dap.ext.vscode')
    local wk = require('which-key')

    wk.register({["<Leader>r"] = { name = "run/debug" }})
    vim.keymap.set('n', '<F3>', function() dap.terminate() end, { desc = "Terminate Debug Session" })
    vim.keymap.set('n', '<F4>', function() dap.restart() end, { desc = "Restart Debug Session" })
    vim.keymap.set('n', '<F5>', function()
      if dap.session() == nil then
        local filesep = package.config:sub(1,1)

        local ws_dirs = vim.lsp.buf.list_workspace_folders()

        if next(ws_dirs) == nil then
          -- print('dapbug: No workspace')
          dap.continue()
        else
          for _, v in pairs(ws_dirs) do
            local lua_launch_file = vim.fs.normalize(v) .. filesep
              .. 'dapconfig.lua'
            local config_table

            local json_launch_file = vim.fs.normalize(v) .. filesep
              .. '.vscode' .. filesep .. 'launch.json'

            -- dapconfig.lua takes priority
            if vim.fn.filereadable(lua_launch_file) == 1 then
              -- print('dapbug: found lualaunch')
              config_table = dofile(lua_launch_file)
              if type(config_table) == 'table' then
                -- print('dapbug: lualaunch table read successfully')
                ui.pick_if_many(
                  config_table,
                  'dapconfig.lua configurations:',
                  function(i) return i.name end,
                  function(c) dap.run(c) end
                )
                return
              else
                error('Error: expected ' .. lua_launch_file ..
                  ' to return a table; returned ' .. type(config_table))
              end
            elseif vim.fn.filereadable(json_launch_file) == 1 then
              -- print('dapbug: found launch.json')
              dap_vs.load_launchjs(json_launch_file, { debugpy = { "python" } })
              dap.continue()
              return
            else
              -- print('dapbug: no launch file found')
              dap.continue()
              return
            end
          end
        end
      else
        -- print('dapbug: session was not nil')
        dap.continue()
        return
      end
    end, { desc = "Debug/Continue" })

    vim.keymap.set('n', '<F6>', function() dap.run_last() end, { desc = "Run previous configuration" })
    vim.keymap.set('n', '<F7>', function() dap.goto_() end, { desc = "Go to cursor" })
    vim.keymap.set('n', '<F9>', function() dap.run_to_cursor() end, { desc = "Run to cursor" })
    vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = "Step over" })
    vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = "Step into" })
    vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = "Step out" })
    vim.keymap.set('n', '<Leader>rb', function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
    vim.keymap.set('n', '<Leader>rB', function() dap.set_breakpoint() end, { desc = "Set breakpoint" })

    vim.keymap.set('n', '<Leader>rc', function()
      local condition = vim.fn.input('Condition expression: ')
      local hit = vim.fn.input('Hit condition: ')
      if condition ~= '' and hit ~= '' then
        dap.set_breakpoint(condition, hit, nil)
      elseif condition ~= '' then
        dap.set_breakpoint(condition, nil, nil)
      elseif hit ~= '' then
        dap.set_breakpoint(nil, hit, nil)
      end
    end, { desc = "Set conditional breakpoint" })

    vim.keymap.set('n', '<Leader>rp', function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, { desc = "Set log point" })

    vim.keymap.set('n', '<Leader>rx', function() dap.clear_breakpoints() end, { desc = "Clear breakpoints" })
    vim.keymap.set('n', '<Leader>rr', function() dap.repl.toggle() end, { desc = "Open REPL" })
    vim.keymap.set('n', '<Leader>rl', function() dap.list_breakpoints(true) end, { desc = "List breakpoints" })

    vim.keymap.set({ 'n', 'v' }, '<Leader>rh', function()
      widgets.hover()
    end, { desc = "Hover" })

    vim.keymap.set({ 'n', 'v' }, '<Leader>rp', function()
      widgets.preview()
    end, { desc = "Hover in preview window" })

    vim.keymap.set('n', '<Leader>rf', function()
      widgets.centered_float(widgets.frames)
    end, { desc = "Frames (floating)" })

    vim.keymap.set('n', '<Leader>rv', function()
      widgets.centered_float(widgets.scopes)
    end, { desc = "Variables (floating)" })

    vim.keymap.set('n', '<Leader>rF', function()
      if DAP_FRAMES_BAR == nil then
        DAP_FRAMES_BAR = widgets.sidebar(widgets.frames)
      end
      DAP_FRAMES_BAR.toggle()
    end, { desc = "Frames (sidebar)" })
    vim.keymap.set('n', '<Leader>rV', function()
      if DAP_SCOPES_BAR == nil then
        DAP_SCOPES_BAR = widgets.sidebar(widgets.scopes)
      end
      DAP_SCOPES_BAR.toggle()
    end, { desc = "Variables (sidebar)" })

    vim.fn.sign_define('DapBreakpoint', { text='', numhl='DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text='', numhl='DiagnosticWarn' })
    vim.fn.sign_define('DapLogPoint', { text='', numhl='DiagnosticInfo' })
    vim.fn.sign_define('DapStopped', { text='', texthl='DiagnosticSignOk' })
    vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DiagnosticWarn' })
    -- vim.fn.sign_define('DapBreakpoint', { text='󰧟', texthl='DiagnosticError' })

    -- repl.commands = vim.tbl_extend('force', repl.commands, {
    --   custom_commands = {
    --     ['.restart'] = function()
    --       dap.restart()
    --       repl.open()
    --       vim.cmd.wincmd('j')
    --     end,
    --     ['.clear'] = repl.clear()
    --   },
    -- })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dap-repl',
      callback = function ()
        vim.keymap.set('i', '<Tab>', '<C-X><C-O>', { buffer = true, desc = 'DAP Omnifunc' })
      end
    })

    dap.adapters.python = {
      type = 'executable',
      command = 'python',
      args = { '-m', 'debugpy.adapter' };
    }

    dap.configurations.python = {
      {
        name = 'Launch file',
        type = 'python',
        request = 'launch',
        program = '${file}',
        pythonPath = 'python',
      },
      {
        name = 'Custom',
        type = 'python',
        request = 'launch',
        program = function()
          local file = vim.fn.input("filename: ", "", "file")
          if file == "" then
            file = "${file}"
          end
          return file
        end,
        args = function()
          local args = {}
          local argstr = vim.fn.input("args: ", "", "file")
          for v in string.gmatch(argstr, "%S+") do
            table.insert(args, v)
          end
          return args
        end,
        pythonPath = 'python',
      },
    }

    -- dap.adapters.codelldb = {
    --   type = 'server',
    --   port = "${port}",
    --   executable = {
    --     -- CHANGE THIS to your path!
    --     command = '/nix/store/k7adbr5mzdci3iwlanr9vya72rmnm311-vscode-extension-vadimcn-vscode-lldb-1.10.0/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb',
    --     args = {"--port", "${port}"},
    --
    --     -- On windows you may have to uncomment this:
    --     -- detached = false,
    --   }
    -- }

    -- dap.configurations.rust = {
    --   { --
    --     -- ... the previous config goes here ...,
    --     initCommands = function()
    --       -- Find out where to look for the pretty printer Python module
    --       local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
    --
    --       local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
    --       local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
    --
    --       local commands = {}
    --       local file = io.open(commands_file, 'r')
    --       if file then
    --         for line in file:lines() do
    --           table.insert(commands, line)
    --         end
    --         file:close()
    --       end
    --       table.insert(commands, 1, script_import)
    --
    --       return commands
    --     end,
    --     -- ...,
    --   }
    -- }


  end
}
