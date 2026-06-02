-- ~/.config/nvim/after/ftplugin/systemverilog.lua
-- SystemVerilog buffer settings. 2-space indent is the common house style in
-- most SV style guides (e.g. lowRISC); change shiftwidth if your team differs.
-- Format-on-demand uses verible-verilog-format via the verible LSP if present.
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.commentstring = "// %s"
