-- ~/.config/nvim/lua/plugins/ui.lua
-- The IDE furniture: a file explorer sidebar, a status line, an indent guide,
-- comment toggling, and auto-pairing of brackets/quotes.

return {
  {
    -- File explorer sidebar (like VS Code's Explorer). Toggle with <C-n> or
    -- <leader>fe; reveal the current file with <leader>fE.
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- file-type icons (needs a Nerd Font)
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-n>", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>fe", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>fE", "<cmd>Neotree reveal<CR>", desc = "Reveal current file in tree" },
      { "<leader>ge", "<cmd>Neotree float git_status<CR>", desc = "Git status (float)" },
      { "<leader>be", "<cmd>Neotree toggle show buffers right<CR>", desc = "Buffer explorer" },
    },
    opts = {
      close_if_last_window = true, -- don't leave a lone tree window when closing buffers
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,   -- show LSP diagnostics in the tree
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        -- Tabs at the top of the tree to switch Files / Buffers / Git, like
        -- VS Code's activity-bar sections.
        winbar = true,
        sources = {
          { source = "filesystem", display_name = " Files" },
          { source = "buffers", display_name = " Buffers" },
          { source = "git_status", display_name = " Git" },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- show expand/collapse arrows on folders
          expander_collapsed = "",
          expander_expanded = "",
        },
        git_status = {
          symbols = {
            added = "✚", modified = "", deleted = "✖", renamed = "󰁕",
            untracked = "", ignored = "", unstaged = "󰄱", staged = "", conflict = "",
          },
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true, -- live-update on external file changes
        group_empty_dirs = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "__pycache__", ".pytest_cache", ".mypy_cache", ".git" },
        },
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none",          -- don't shadow the leader key inside the tree
          ["P"] = { "toggle_preview", config = { use_float = true } }, -- peek a file
          ["H"] = "toggle_hidden",
          ["o"] = "open",
          ["/"] = "fuzzy_finder",        -- filter the tree by typing, VS Code-style
          ["<C-x>"] = "open_split",
          ["<C-v>"] = "open_vsplit",
        },
      },
    },
  },
  {
    -- Status line at the bottom: mode, git branch, diagnostics, file info.
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "solarized",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
    },
  },
  {
    -- Vertical indentation guides.
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },
  {
    -- gcc to comment a line, gc in visual mode for a selection.
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    -- Auto-close brackets, quotes, etc., and integrate with cmp so completing
    -- a function adds the parentheses.
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done())
      end
    end,
  },
  {
    -- Pops up a panel showing available keybindings as you type a prefix.
    -- Hugely helpful while you're still learning the bindings.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
