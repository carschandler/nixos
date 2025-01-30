return {
  {
    cond = not vim.g.vscode,
    "mfussenegger/nvim-dap",

    config = function()
      local dap = require("dap")
      local widgets = require("dap.ui.widgets")
      local repl = require("dap.repl")
      local ui = require("dap.ui")
      local dap_vs = require("dap.ext.vscode")
      local wk = require("which-key")

      dap.defaults.fallback.terminal_win_cmd = "tabnew"

      local running_handle = nil
      local exited = false
      local poll = require("fidget.poll")

      local poller = poll.Poller({
        name = "dap",
        poll = function()
          if running_handle then
            running_handle.message = require("dap").status()
          end
          return true
        end,
      })

      for _, message in ipairs({
        "launch",
        "continue",
        "next",
        "stepIn",
        "stepOut",
        "stepBack",
        "stepInTargets",
      }) do
        dap.listeners.after[message]["dap_conf"] = function(session, _)
          local title
          if session.current_frame then
            title = "in " .. vim.fs.basename(session.current_frame.source.path)
          else
            title = ""
          end

          running_handle = require("fidget.progress").handle.create({
            lsp_client = {
              name = session.config.type,
            },
            title = title,
            -- message = "Executing",
            cancellable = true,
          })
          poller:start_polling(5)
        end
      end

      dap.listeners.after["event_exited"]["conf"] = function(_, body)
        if running_handle then
          running_handle.message = "Exited with code " .. body.exitCode
          running_handle.done = true
          exited = true
        end
      end

      dap.listeners.after["event_terminated"]["conf"] = function(_, _)
        if running_handle and not exited then
          running_handle.message = "Terminated"
          running_handle.done = true
          exited = false
        end
      end

      for _, message in ipairs({ "event_stopped" }) do
        dap.listeners.after[message]["conf"] = function(_, _)
          if running_handle then
            -- running_handle.message = "Execution complete!"
            running_handle.done = true
            -- if message ~= "event_terminated" then
            --   require("fidget.notification").clear()
            -- end
          end
        end
      end

      if wk then
        wk.add({ "<Leader>r", group = "run/debug" })
      end

      vim.keymap.set("n", "<F3>", function()
        dap.terminate()
      end, { desc = "Terminate Debug Session" })
      vim.keymap.set("n", "<F4>", function()
        dap.restart()
      end, { desc = "Restart Debug Session" })
      vim.keymap.set("n", "<F5>", function()
        if dap.session() == nil then
          local filesep = package.config:sub(1, 1)

          local ws_dirs = vim.lsp.buf.list_workspace_folders()

          if next(ws_dirs) == nil then
            dap.continue()
          else
            for _, ws_dir in pairs(ws_dirs) do
              local lua_launch_file = vim.fs.normalize(ws_dir) .. filesep .. "dapconfig.lua"
              local config_table

              local json_launch_file = vim.fs.normalize(ws_dir) .. filesep .. ".vscode" .. filesep .. "launch.json"

              -- dapconfig.lua takes priority
              if vim.fn.filereadable(lua_launch_file) == 1 then
                config_table = dofile(lua_launch_file)
                if type(config_table) == "table" then
                  ui.pick_if_many(config_table, "dapconfig.lua configurations:", function(i)
                    return i.name
                  end, function(c)
                    dap.run(c)
                  end)
                  return
                else
                  error("Error: expected " .. lua_launch_file .. " to return a table; returned " .. type(config_table))
                end
              -- elseif vim.fn.filereadable(json_launch_file) == 1 then
              --   -- TODO: if in the workspace root, then nvim-dap picks this up
              --   -- by default and will duplicate entries, but not if in a child
              --   -- directory
              --   -- local vscode_type_to_filetypes = { debugpy = { "python" } }
              --   -- dap_vs.load_launchjs(json_launch_file, vscode_type_to_filetypes)
              --   dap.continue()
              --   return
              else
                dap.continue()
                return
              end
            end
          end
        else
          dap.continue()
          return
        end
      end, { desc = "Debug/Continue" })

      vim.keymap.set("n", "<F6>", function()
        dap.run_last()
      end, { desc = "Run previous configuration" })
      vim.keymap.set("n", "<F7>", function()
        dap.goto_()
      end, { desc = "Go to cursor" })
      vim.keymap.set("n", "<F9>", function()
        dap.run_to_cursor()
      end, { desc = "Run to cursor" })
      vim.keymap.set("n", "<F10>", function()
        dap.step_over()
      end, { desc = "Step over" })
      vim.keymap.set("n", "<F11>", function()
        dap.step_into()
      end, { desc = "Step into" })
      vim.keymap.set("n", "<F12>", function()
        dap.step_out()
      end, { desc = "Step out" })
      vim.keymap.set("n", "<Leader>rb", function()
        dap.toggle_breakpoint()
      end, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<Leader>rB", function()
        dap.set_breakpoint()
      end, { desc = "Set breakpoint" })

      vim.keymap.set("n", "<Leader>rc", function()
        local condition = vim.fn.input("Condition expression: ")
        local hit = vim.fn.input("Hit condition: ")
        if condition ~= "" and hit ~= "" then
          dap.set_breakpoint(condition, hit, nil)
        elseif condition ~= "" then
          dap.set_breakpoint(condition, nil, nil)
        elseif hit ~= "" then
          dap.set_breakpoint(nil, hit, nil)
        end
      end, { desc = "Set conditional breakpoint" })

      vim.keymap.set("n", "<Leader>rm", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "Set log point" })

      vim.keymap.set("n", "<Leader>rx", function()
        dap.clear_breakpoints()
      end, { desc = "Clear breakpoints" })

      vim.keymap.set("n", "<Leader>rr", function()
        if not dap.repl.close({ mode = "toggle" }) then
          local _, win = dap.repl.open({}, "vsplit")
          vim.api.nvim_set_current_win(win)
        end
      end, { desc = "Open REPL" })
      vim.keymap.set("n", "<Leader>rR", function()
        if not dap.repl.close({ mode = "toggle" }) then
          local _, win = dap.repl.open({ height = 15 })
          vim.api.nvim_set_current_win(win)
        end
      end, { desc = "Open REPL Horizontally" })

      vim.keymap.set("n", "<Leader>rl", function()
        dap.list_breakpoints(true)
      end, { desc = "List breakpoints" })

      vim.keymap.set({ "n", "v" }, "<Leader>rh", function()
        widgets.hover()
      end, { desc = "Hover" })

      vim.keymap.set({ "n", "v" }, "<Leader>rh", function()
        widgets.hover()
      end, { desc = "Hover" })
      vim.keymap.set({ "n", "v" }, "<Leader>k", function()
        widgets.hover()
      end, { desc = "Hover" })

      vim.keymap.set({ "n", "v" }, "<Leader>rp", function()
        widgets.preview()
      end, { desc = "Hover in preview window" })
      vim.keymap.set({ "n", "v" }, "<Leader>K", function()
        widgets.preview()
      end, { desc = "Hover in preview window" })

      vim.keymap.set("n", "<Leader>rf", function()
        widgets.centered_float(widgets.frames)
      end, { desc = "Frames (floating)" })

      vim.keymap.set("n", "<Leader>rv", function()
        widgets.centered_float(widgets.scopes)
      end, { desc = "Variables (floating)" })

      vim.keymap.set("n", "<Leader>rF", function()
        if DAP_FRAMES_BAR == nil then
          DAP_FRAMES_BAR = widgets.sidebar(widgets.frames)
        end
        DAP_FRAMES_BAR.toggle()
      end, { desc = "Frames (sidebar)" })
      vim.keymap.set("n", "<Leader>rV", function()
        if DAP_SCOPES_BAR == nil then
          DAP_SCOPES_BAR = widgets.sidebar(widgets.scopes)
        end
        DAP_SCOPES_BAR.toggle()
      end, { desc = "Variables (sidebar)" })

      vim.fn.sign_define("DapBreakpoint", { text = "", numhl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", numhl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "", numhl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignOk" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn" })
      -- vim.fn.sign_define("DapBreakpoint", { text = "󰧟", texthl = "DiagnosticError" })

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

      dap.adapters.debugpy = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          name = "Launch file",
          type = "debugpy",
          request = "launch",
          program = "${file}",
          pythonPath = "python",
          console = "integratedTerminal",
        },
        {
          name = "Custom",
          type = "debugpy",
          request = "launch",
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
          pythonPath = "python",
        },
      }

      -- This is how we would configure rust if not using rustacean.nvim

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
    end,
  },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   cond = not vim.g.vscode,
  --   dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  --   opts = {},
  -- },
}
