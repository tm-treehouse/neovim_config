-- ~/.config/nvim/lua/plugins/dap.lua
-- Debugging (your requested feature). nvim-dap is the Debug Adapter Protocol
-- client; nvim-dap-python wires it up to Python's debugpy; nvim-dap-ui gives
-- you the VS Code-like panels (scopes, breakpoints, call stack, watches).

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",     -- required by dap-ui
      "theHamsta/nvim-dap-virtual-text", -- inline variable values while debugging
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          -- Use debugpy from mason's install. Run :MasonInstall debugpy once,
          -- or rely on mason-tool-installer below.
          local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
          require("dap-python").setup(debugpy)
        end,
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Debug: Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue / Start" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Debug: Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: Step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
      -- Debug the nearest test method / class (from nvim-dap-python)
      { "<leader>dn", function() require("dap-python").test_method() end, desc = "Debug: Nearest test method" },
      { "<leader>df", function() require("dap-python").test_class() end, desc = "Debug: Test class" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})

      -- Auto-open/close the debug UI when a session starts/ends.
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn" })
    end,
  },
  {
    -- Ensures debugpy gets installed automatically via mason.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "debugpy" },
    },
  },
}
