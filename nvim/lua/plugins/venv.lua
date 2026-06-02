-- ~/.config/nvim/lua/plugins/venv.lua
-- venv-selector: pick a Python virtualenv from inside Neovim and have pyright
-- (and any other Python LSP) re-attach against it. Supports uv, poetry, pyenv,
-- pipenv, hatch, and plain .venv directories.
--
-- Use it from a Python project's root:
--   :VenvSelect          -- search for venvs and pick one
--   :VenvSelectCached    -- reuse the last venv chosen for this cwd
--
-- The plugin remembers your choice per directory, so the second invocation in
-- a project is just :VenvSelectCached (or a keymap, below).

return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp", -- the rewritten branch is the supported one
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    -- :VenvSelect is the entry point; lazy-load on first use.
    cmd = { "VenvSelect", "VenvSelectCached" },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Python: select venv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Python: use cached venv" },
    },
    opts = {
      settings = {
        options = {
          -- After picking a venv, notify so you can see which one was selected.
          notify_user_on_venv_activation = true,
          -- Remember the choice per cwd so subsequent sessions can reuse it.
          cached_venv_automatic_activation = true,
        },
        search = {
          -- Default searches catch most layouts: poetry's central cache, uv's
          -- in-project .venv, pyenv-virtualenv, plus generic ~/.virtualenvs.
          -- Add more entries here for any non-standard locations your team uses.
          my_venvs = {
            command = "fd 'python$' ~/.virtualenvs --full-path --color never -E /proc",
          },
        },
      },
    },
  },
}
