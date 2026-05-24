-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Treesitter (nvim-treesitter 1.0 "main" branch). This is the post-2025 rewrite,
-- which is a different plugin from the old "master" branch: there is no longer a
-- require("nvim-treesitter.configs").setup{} entry point. Instead:
--   * parsers are installed via require("nvim-treesitter").install{...}
--   * highlighting is started per-buffer with vim.treesitter.start()
--   * indentation uses Neovim's built-in treesitter indentexpr
--   * incremental_selection was removed upstream (no replacement here)
--   * textobjects moved to require("nvim-treesitter-textobjects").setup{}
--     plus explicit keymaps via the .select / .move modules.
--
-- Requires the tree-sitter CLI on your PATH to compile parsers:
--   macOS:  brew install tree-sitter
--   (or:    cargo install tree-sitter-cli / npm install -g tree-sitter-cli)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",        -- the 1.0 rewrite; master is the old, frozen plugin
    lazy = false,           -- load at startup so parsers/highlight are ready
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "python", "lua", "vim", "vimdoc", "query",
        "json", "yaml", "toml", "markdown", "markdown_inline",
        "bash", "dockerfile", "gitignore", "html", "css",
        "c", "cpp", "verilog", -- C/C++ and (System)Verilog; the `verilog`
                               -- parser covers both Verilog and SystemVerilog.
      }

      -- Install any parsers that aren't present yet. install() is async and
      -- returns immediately; already-installed parsers are skipped.
      require("nvim-treesitter").install(parsers)

      -- Start highlighting (and treesitter-based indent) whenever we open a
      -- buffer whose language has a parser. This replaces the old
      -- highlight={enable=true} / indent={enable=true} option tables.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft) or ft
          -- language.add() returns false if no parser is available; only start
          -- highlighting when one is, so we don't error on unknown filetypes.
          if pcall(vim.treesitter.language.add, lang) then
            pcall(vim.treesitter.start, args.buf, lang)
            -- Use treesitter for indentation (experimental but works well).
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    -- Function/class/parameter text objects, e.g. `vaf` selects a function,
    -- `dif` deletes inside a function. Rebuilt on the textobjects main branch.
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true, -- jump forward to a textobj, like targets.vim
          selection_modes = {
            ["@function.outer"] = "V", -- linewise for whole functions
            ["@class.outer"] = "V",
          },
        },
        move = {
          set_jumps = true, -- record moves in the jumplist
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Select text objects (visual + operator-pending modes).
      local sel = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }
      for lhs, capture in pairs(sel) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(capture, "textobjects")
        end, { desc = "TS select " .. capture })
      end

      -- Movement between functions/classes.
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Previous class start" })
    end,
  },
}
