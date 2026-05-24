-- ~/.config/nvim/lua/plugins/telescope.lua
-- Telescope is your fuzzy finder: file search (like Ctrl+P), live grep across
-- the project (like Ctrl+Shift+F), buffer switching, and much more.

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Native fzf sorter for much faster, more accurate matching.
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep in project" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Project diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
      -- Quick-open file search, mirroring VS Code's Ctrl+P muscle memory.
      { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          -- Disable treesitter highlighting in the preview pane. Telescope's
          -- stable 0.1.x branch calls the old nvim-treesitter API (ft_to_lang),
          -- which the treesitter "main" rewrite removed -- so leaving this on
          -- throws "attempt to call field 'ft_to_lang' (a nil value)" on every
          -- preview. Previews fall back to Vim's regex syntax highlighting,
          -- which looks nearly identical in the small preview pane.
          preview = {
            treesitter = false,
          },
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
