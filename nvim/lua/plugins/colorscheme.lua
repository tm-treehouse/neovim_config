-- ~/.config/nvim/lua/plugins/colorscheme.lua
-- Two themes are installed. Solarized is active; Tokyo Night stays available
-- as an alternative. To switch, change which colorscheme is applied below
-- (or just run `:colorscheme tokyonight` / `:colorscheme solarized` at runtime).

return {
  {
    -- Solarized (active). maxmx03's modern Lua port with Treesitter + LSP support.
    "maxmx03/solarized.nvim",
    lazy = false,    -- load at startup
    priority = 1000, -- load before other plugins so UI inherits its colors
    ---@type solarized.config
    opts = {
      transparent = { enabled = false },
      -- palette = "solarized", -- the classic palette; "selenized" is an alt option
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
    config = function(_, opts)
      -- Solarized has a light and a dark variant chosen via 'background'.
      -- Flip to "light" if you prefer the light Solarized palette.
      vim.o.background = "dark"
      require("solarized").setup(opts)
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    -- Tokyo Night (installed but not auto-applied). Run :colorscheme tokyonight
    -- to switch to it, or make it active by moving the colorscheme call here
    -- and removing it from the Solarized spec above.
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "night", -- options: storm, moon, night, day
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
  },
}
