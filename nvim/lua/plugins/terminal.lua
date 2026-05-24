-- ~/.config/nvim/lua/plugins/terminal.lua
-- Terminal integration via toggleterm.nvim: toggleable floating and split
-- terminals, similar to VS Code's integrated terminal panel. Bound under the
-- <leader>t prefix.

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      -- Quick toggles for each layout. The default <C-\> also toggles the last
      -- used terminal (set in opts below).
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal: float" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal: horizontal split" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal: vertical split" },
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Terminal: toggle last" },
    },
    opts = {
      -- <C-\> toggles the terminal from almost anywhere (works in normal/insert).
      open_mapping = [[<c-\>]],
      direction = "float",          -- default layout when no direction is given
      float_opts = { border = "rounded" },
      size = function(term)
        -- Sensible sizes: ~40% height for horizontal, ~40% width for vertical.
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.4)
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4)
        end
      end,
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
      persist_mode = true,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Terminal-mode keymaps: make moving out of the terminal feel natural,
      -- so you're not stuck having to remember <C-\><C-n> to escape.
      local function term_keymaps()
        local function tmap(lhs, rhs, desc)
          vim.keymap.set("t", lhs, rhs, { buffer = 0, desc = desc })
        end
        tmap("<Esc><Esc>", [[<C-\><C-n>]], "Exit terminal mode")
        tmap("<C-h>", [[<Cmd>wincmd h<CR>]], "Go to left window")
        tmap("<C-j>", [[<Cmd>wincmd j<CR>]], "Go to lower window")
        tmap("<C-k>", [[<Cmd>wincmd k<CR>]], "Go to upper window")
        tmap("<C-l>", [[<Cmd>wincmd l<CR>]], "Go to right window")
      end
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        group = vim.api.nvim_create_augroup("user_toggleterm", { clear = true }),
        callback = term_keymaps,
      })

      -- A dedicated lazygit terminal, if lazygit is installed. <leader>tg opens
      -- a full-screen floating git UI — one of the nicest VS Code-like touches.
      local ok, Terminal = pcall(function()
        return require("toggleterm.terminal").Terminal
      end)
      if ok and vim.fn.executable("lazygit") == 1 then
        local lazygit = Terminal:new({
          cmd = "lazygit",
          direction = "float",
          float_opts = { border = "rounded" },
          hidden = true,
        })
        vim.keymap.set("n", "<leader>tg", function()
          lazygit:toggle()
        end, { desc = "Terminal: lazygit" })
      end
    end,
  },
}
