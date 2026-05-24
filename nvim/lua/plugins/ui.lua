-- ~/.config/nvim/lua/plugins/ui.lua
-- The IDE furniture: a file explorer sidebar, a status line, an indent guide,
-- comment toggling, and auto-pairing of brackets/quotes.

return {
  {
    -- File explorer sidebar (like VS Code's Explorer). Toggle with <leader>e... wait,
    -- that's diagnostics — we use <leader>fe / <C-n> here to avoid the clash.
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
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true, -- live-update on external file changes
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { "__pycache__", ".pytest_cache", ".mypy_cache" },
        },
      },
      window = { width = 32 },
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
