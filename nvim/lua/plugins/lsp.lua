-- ~/.config/nvim/lua/plugins/lsp.lua
-- Language Server Protocol: the engine behind go-to-definition, hover docs,
-- diagnostics, rename, and code actions. We use pyright (types/completion)
-- and ruff (fast linting + formatting) for Python.
--
-- This file targets Neovim 0.11+, which ships a native LSP API:
--   * vim.lsp.config('name', {...})  -- merge settings into a server config
--   * vim.lsp.enable('name')         -- activate a server (auto-attaches by ft)
-- nvim-lspconfig still provides the per-server defaults (cmd, root markers,
-- filetypes) under its lsp/ directory; we just layer our settings on top.
-- mason-lspconfig's `automatic_enable` calls vim.lsp.enable() for every server
-- it installs, so we don't enable them by hand.

return {
  {
    -- Mason installs LSP servers / tools without you touching the system.
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = { border = "rounded" },
    },
  },
  {
    -- Bridges mason and the native LSP: installs servers and auto-enables them.
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig", -- provides the base configs under lsp/
    },
    opts = {
      ensure_installed = { "pyright", "ruff", "lua_ls" },
      automatic_enable = true, -- runs vim.lsp.enable() for installed servers
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- advertises completion capabilities to servers
    },
    config = function()
      -- Capabilities: tell servers nvim-cmp can handle rich completion items.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Diagnostic display: nicer signs + bordered floating windows.
      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        float = { border = "rounded", source = true },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "»",
          },
        },
      })

      -- Rounded borders for all floating windows (hover, signature help, etc.).
      -- This replaces the old, now-deprecated vim.lsp.with(handlers...) approach.
      vim.o.winborder = "rounded"

      -- Apply our completion capabilities to every server ('*' is a wildcard
      -- config that merges into all of them).
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Pyright: type checking + completion. ruff owns linting/formatting and
      -- import organization, so we tell pyright to stay out of those lanes.
      vim.lsp.config("pyright", {
        settings = {
          pyright = {
            disableOrganizeImports = true, -- ruff handles import organization
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly", -- "workspace" for full-project checks
              typeCheckingMode = "basic",        -- "strict" if you want more rigor
            },
          },
        },
      })

      -- Ruff: extremely fast linter + formatter (replaces flake8/isort/black).
      vim.lsp.config("ruff", {
        -- Tweak rules via init_options.settings, e.g.:
        -- init_options = { settings = { lineLength = 88 } },
      })

      -- Lua LS, mostly so editing this config is pleasant.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } }, -- recognize the `vim` global
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Buffer-local keymaps, set only once a server attaches to the buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local function bmap(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end

          -- Navigation / peeking
          bmap("gd", vim.lsp.buf.definition, "Go to definition")
          bmap("gD", vim.lsp.buf.declaration, "Go to declaration")
          bmap("gi", vim.lsp.buf.implementation, "Go to implementation")
          bmap("gr", vim.lsp.buf.references, "List references")
          bmap("gt", vim.lsp.buf.type_definition, "Go to type definition")

          -- Hover docs (peek). Press K, then K again to enter the float and scroll.
          bmap("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover documentation")
          vim.keymap.set("i", "<C-k>",
            function() vim.lsp.buf.signature_help({ border = "rounded" }) end,
            { buffer = ev.buf, desc = "LSP: Signature help" })

          -- Refactoring
          bmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          bmap("<leader>ca", vim.lsp.buf.code_action, "Code action")

          -- Diagnostics navigation
          bmap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
          bmap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          bmap("<leader>e", vim.diagnostic.open_float, "Show diagnostic detail")

          -- Format current buffer
          bmap("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

          -- Let pyright own hover so you don't get duplicate, less-useful hover
          -- text from ruff.
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },
}
