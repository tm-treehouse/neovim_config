-- ~/.config/nvim/after/ftplugin/c.lua
-- C buffer settings. Many C/C++ projects use 4-space indents; adjust shiftwidth
-- to taste (the Linux kernel uses real tabs at width 8, for example).
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.cindent = true       -- C-style auto-indent
vim.opt_local.commentstring = "// %s"
