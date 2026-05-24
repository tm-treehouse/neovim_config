# Neovim config for Python development

A modular [lazy.nvim](https://github.com/folke/lazy.nvim)-based setup aimed at
developers coming from VS Code. Includes LSP (pyright + ruff), autocomplete,
hover/peek/go-to-definition, DAP debugging, fuzzy finding, a file tree, and the
usual IDE quality-of-life pieces.

## Prerequisites

Install these on your system first (Neovim itself does the rest via Mason):

- **Neovim 0.10+** (0.11+ recommended; the diagnostic config uses newer APIs)
- **git**, **make**, and a **C compiler** (gcc/clang) — for treesitter & fzf-native
- **Node.js** — pyright is distributed via npm and Mason needs node to install it
- **Python 3** with `pip`
- **ripgrep** (`rg`) — for Telescope's live grep
- **fd** (optional, faster file finding)
- A **Nerd Font** set in your terminal — for icons (e.g. JetBrainsMono Nerd Font)

On macOS:

    brew install neovim ripgrep fd node make

On Debian/Ubuntu:

    sudo apt install neovim ripgrep fd-find nodejs npm build-essential

## Install

1. Back up any existing config:

       mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

2. Copy this folder to `~/.config/nvim`:

       cp -r nvim ~/.config/nvim

3. (Recommended) Create the dedicated Neovim Python provider venv so plugins
   that need `pynvim` keep working even when you switch project virtualenvs:

       python3 -m venv ~/.virtualenvs/neovim
       ~/.virtualenvs/neovim/bin/pip install pynvim

4. Launch Neovim:

       nvim

   On first launch lazy.nvim bootstraps itself and installs every plugin.
   Mason then installs pyright, ruff, lua_ls, and debugpy. Give it a minute,
   then quit and reopen.

5. Verify health:

       :checkhealth

## Per-project Python setup

pyright and debugpy pick up the interpreter from the active environment. The
simplest reliable approach is to **activate your project's virtualenv before
launching nvim**:

    source .venv/bin/activate
    nvim .

pyright will then resolve your project's installed packages for completion and
type checking. (If you'd rather switch environments without restarting nvim,
ask me to add the `swenv.nvim` or `venv-selector.nvim` plugin.)

## Keymap cheatsheet

Leader is **Space**. Press `<leader>` and pause to see the which-key popup.

### LSP / code intelligence

| Key          | Action                          |
|--------------|---------------------------------|
| `gd`         | Go to definition                |
| `gD`         | Go to declaration               |
| `gi`         | Go to implementation            |
| `gr`         | List references                 |
| `gt`         | Go to type definition           |
| `K`          | Hover docs (press again to enter the float) |
| `<C-k>` (insert) | Signature help              |
| `<leader>rn` | Rename symbol                   |
| `<leader>ca` | Code action                     |
| `<leader>cf` | Format buffer                   |
| `[d` / `]d`  | Previous / next diagnostic      |
| `<leader>e`  | Show diagnostic detail (float)  |

### Completion (insert mode)

| Key          | Action                          |
|--------------|---------------------------------|
| `<C-Space>`  | Trigger completion              |
| `<Tab>` / `<S-Tab>` | Next / previous item; jump snippet placeholders |
| `<CR>`       | Accept selected item            |
| `<C-b>` / `<C-f>` | Scroll docs popup          |
| `<C-e>`      | Abort completion                |

### Debugging (DAP)

| Key          | Action                          |
|--------------|---------------------------------|
| `<leader>db` | Toggle breakpoint               |
| `<leader>dB` | Conditional breakpoint          |
| `<leader>dc` | Continue / start                |
| `<leader>di` | Step into                       |
| `<leader>do` | Step over                       |
| `<leader>dO` | Step out                        |
| `<leader>du` | Toggle debug UI                 |
| `<leader>dr` | Toggle REPL                     |
| `<leader>dt` | Terminate                       |
| `<leader>dn` | Debug nearest test method       |
| `<leader>df` | Debug test class                |

### Finding things (Telescope)

| Key          | Action                          |
|--------------|---------------------------------|
| `<C-p>` / `<leader>ff` | Find files            |
| `<leader>fg` | Live grep across project        |
| `<leader>fb` | Switch buffers                  |
| `<leader>fr` | Recent files                    |
| `<leader>fw` | Grep word under cursor          |
| `<leader>fs` | Document symbols                |
| `<leader>fd` | Project diagnostics             |

### Files & windows

| Key          | Action                          |
|--------------|---------------------------------|
| `<C-n>` / `<leader>fe` | Toggle file tree      |
| `<leader>fE` | Reveal current file in tree     |
| `<C-h/j/k/l>`| Move between windows            |
| `<S-h>` / `<S-l>` | Previous / next buffer     |
| `<leader>bd` | Close buffer                    |
| `gcc` / `gc` | Toggle comment (line / selection) |
| `<C-s>`      | Save                            |

## Layout

    ~/.config/nvim/
    ├── init.lua                  # entry point, bootstraps lazy.nvim
    ├── lua/
    │   ├── config/
    │   │   ├── options.lua       # editor settings
    │   │   └── keymaps.lua       # general keymaps
    │   └── plugins/
    │       ├── colorscheme.lua
    │       ├── treesitter.lua
    │       ├── lsp.lua           # pyright + ruff + mason
    │       ├── completion.lua    # nvim-cmp + snippets
    │       ├── dap.lua           # debugging
    │       ├── telescope.lua     # fuzzy finder
    │       └── ui.lua            # file tree, statusline, etc.
    └── after/ftplugin/
        └── python.lua            # PEP 8 buffer settings

Each plugin lives in its own file, so adding or removing a feature is just a
matter of editing or deleting one file under `lua/plugins/`.

## Common tweaks

- **Stricter type checking:** in `lua/plugins/lsp.lua`, set
  `typeCheckingMode = "strict"` and/or `diagnosticMode = "workspace"`.
- **Different theme:** two themes are installed — Solarized (active) and Tokyo
  Night. Switch at runtime with `:colorscheme tokyonight` or `:colorscheme
  solarized`, or make the change permanent in `lua/plugins/colorscheme.lua`.
  For Solarized, flip `vim.o.background` between `"dark"` and `"light"`, and try
  the `variant` option ("spring"/"summer"/"autumn"/"winter") or the `selenized`
  palette.
- **Format on save:** ask me to add a small autocmd; I left it off so saving
  never surprises you with reformatting.
