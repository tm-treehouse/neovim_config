-- ~/.config/nvim/lua/config/keymaps.lua
-- General, non-plugin keymaps. Plugin-specific maps live with their plugin spec.

local map = vim.keymap.set

-- Clear search highlight with Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Exit insert mode by typing jj quickly (fires within 'timeoutlen', 400ms)
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Save / quit (familiar to most editors)
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Window navigation with Ctrl + hjkl (like VS Code's Ctrl+W then arrow, but faster)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Maximize current window (F) / restore all windows to equal size (f).
-- NOTE: this overrides Vim's built-in `f` (find-char-forward) and `F`
-- (find-char-backward) motions in normal mode, by deliberate choice.
map("n", "F", "<C-w>_<C-w>|", { desc = "Maximize current window" })
map("n", "f", "<C-w>=", { desc = "Equalize all windows" })

-- Move selected lines up/down (Alt+j / Alt+k), like VS Code's Alt+Up/Down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when jumping half-pages and through search results
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better indenting: stay in visual mode after shifting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste over a selection without clobbering the yank register
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
