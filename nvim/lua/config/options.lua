-- ~/.config/nvim/lua/config/options.lua
-- Core editor settings. These run before any plugins load.

local opt = vim.opt
local g = vim.g

-- Leader key (must be set before plugins). Space is the common modern choice.
g.mapleader = " "
g.maplocalleader = "\\"

-- Line numbers
opt.number = true

-- Indentation: 4 spaces for Python (PEP 8). Treesitter/ftplugins refine per-language.
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true   -- case-sensitive only if you type a capital
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split" -- live-preview :s/foo/bar substitutions as you type

-- UI
opt.termguicolors = true   -- 24-bit color (needed for modern themes)
opt.signcolumn = "yes"     -- always show sign column so text doesn't jump
opt.cursorline = true
opt.scrolloff = 8          -- keep 8 lines visible above/below cursor
opt.sidescrolloff = 8
opt.wrap = false
opt.breakindent = true     -- wrapped lines keep their indent (matters when wrap is on)
opt.splitright = true
opt.splitbelow = true

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"  -- use system clipboard for yank/paste
opt.undofile = true            -- persistent undo across sessions
opt.undodir = vim.fn.stdpath("state") .. "/undo" -- explicit, guaranteed-to-exist below
opt.swapfile = false
opt.confirm = true             -- prompt to save instead of erroring on :q with changes
opt.history = 1000             -- remember more command/search history (default 50)
opt.updatetime = 250           -- faster CursorHold (used by LSP hover hints)
opt.timeoutlen = 400           -- time to wait for a mapped sequence (which-key)
opt.completeopt = "menu,menuone,noselect"

-- Make sure the persistent-undo directory exists so undofile never silently fails.
local undodir = vim.fn.stdpath("state") .. "/undo"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

-- Better display of invisible chars when you :set list
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Python provider: point Neovim at a stable interpreter so plugins that need
-- the `pynvim` package don't break when you switch project virtualenvs.
-- Create it once with:  python3 -m venv ~/.virtualenvs/neovim && \
--   ~/.virtualenvs/neovim/bin/pip install pynvim
local nvim_python = vim.fn.expand("~/.virtualenvs/neovim/bin/python")
if vim.fn.executable(nvim_python) == 1 then
  g.python3_host_prog = nvim_python
end
