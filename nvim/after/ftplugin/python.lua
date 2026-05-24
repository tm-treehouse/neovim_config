-- ~/.config/nvim/after/ftplugin/python.lua
-- Python-specific buffer settings (PEP 8). `after/ftplugin` runs after the
-- built-in filetype plugin, so these win.

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.textwidth = 88

-- Treat docstring/comment wrapping sensibly.
vim.opt_local.formatoptions:remove("t") -- don't auto-wrap code
vim.opt_local.formatoptions:append("croqj")
