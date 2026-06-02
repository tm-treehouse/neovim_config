# Neovim Keystroke Cheatsheet

> **Leader key = `Space`**
> Throughout this document, `<leader>` means the **Space** bar. So `<leader>ff`
> means press *Space*, then *f*, then *f*. The local leader is `\` (backslash).
>
> Tip: pause after pressing `<leader>` (or any prefix) and **which-key** pops up
> to show you what's available next.

---

## Survival kit

The handful that get you through the day:

| Key | Action |
|-----|--------|
| `<C-s>` | Save (normal & insert mode) |
| `jj` | Exit insert mode (type quickly) |
| `<Esc>` | Clear search highlight (normal mode) |
| `<C-\>` | Toggle terminal from anywhere |
| `<C-p>` | Find files (fuzzy) |
| `gd` | Go to definition |
| `K` | Hover docs |
| `<C-n>` | Toggle file tree |

---

## Finding things — Telescope

| Key | Action |
|-----|--------|
| `<C-p>` / `<leader>ff` | Find files (like VS Code Ctrl+P) |
| `<leader>fg` | Live grep across project (Ctrl+Shift+F) |
| `<leader>fb` | Switch buffers |
| `<leader>fr` | Recent files |
| `<leader>fw` | Grep word under cursor |
| `<leader>fs` | Document symbols |
| `<leader>fd` | Project diagnostics |
| `<leader>fh` | Search help tags |

---

## File tree — neo-tree

| Key | Action |
|-----|--------|
| `<C-n>` / `<leader>fe` | Toggle file explorer |
| `<leader>fE` | Reveal current file in tree |
| `<leader>be` | Buffer explorer |
| `<leader>ge` | Git status (floating) |

**Inside the tree:**

| Key | Action |
|-----|--------|
| `o` / `<CR>` | Open file |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `/` | Filter tree by typing |
| `P` | Preview file in a float |
| `H` | Toggle hidden files |

The tabs at the top of the tree switch between **Files**, **Buffers**, and **Git**.

---

## Code intelligence — LSP

Works in Python (pyright/ruff), C/C++ (clangd), and SystemVerilog (svls/verible).

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | List references |
| `gt` | Go to type definition |
| `K` | Hover docs (press `K` again to enter & scroll the float) |
| `<C-k>` *(insert)* | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (quick fixes, imports) |
| `<leader>cf` | Format buffer |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>e` | Show full diagnostic message |

---

## Autocomplete — nvim-cmp *(insert mode)*

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion manually |
| `<Tab>` / `<S-Tab>` | Cycle items; jump snippet placeholders |
| `<CR>` | Accept selected item |
| `<C-b>` / `<C-f>` | Scroll docs popup |
| `<C-e>` | Dismiss menu |

---

## Debugging — DAP

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue / start session |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle debug UI |
| `<leader>dr` | Toggle REPL |
| `<leader>dt` | Terminate |
| `<leader>dl` | Run last |
| `<leader>dn` | Debug nearest test method |
| `<leader>df` | Debug test class |

---

## Terminal — toggleterm

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal (from anywhere) |
| `<leader>tf` | Float terminal |
| `<leader>th` | Horizontal split terminal |
| `<leader>tv` | Vertical split terminal |
| `<leader>tt` | Toggle last terminal |
| `<leader>tg` | lazygit (if installed) |

**Inside a terminal:**

| Key | Action |
|-----|--------|
| `<Esc><Esc>` | Exit terminal mode |
| `<C-h/j/k/l>` | Move to another window |

---

## Windows

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between splits |
| `<C-Up>` / `<C-Down>` | Resize height |
| `<C-Left>` / `<C-Right>` | Resize width |
| `F` | Maximize current window |
| `f` | Equalize all windows |

> **Note:** `F` and `f` deliberately override Vim's built-in find-character
> motions in this config — that was an intentional choice.

---

## Buffers & editing

| Key | Action |
|-----|--------|
| `<S-l>` / `<S-h>` | Next / previous buffer |
| `<leader>bd` | Close buffer |
| `<A-j>` / `<A-k>` *(visual)* | Move selected lines down / up |
| `gcc` | Comment a line |
| `gc` *(visual)* | Comment a selection |
| `<leader>p` *(visual)* | Paste over selection without losing yank |
| `<` / `>` *(visual)* | Indent left / right (keeps selection) |

**Treesitter text objects** (use with `v`, `d`, `c`, `y`, etc.):

| Key | Selects |
|-----|---------|
| `af` / `if` | A function / inside a function |
| `ac` / `ic` | A class / inside a class |
| `aa` / `ia` | A parameter / inside a parameter |
| `]f` / `[f` | Jump to next / previous function |
| `]c` / `[c` | Jump to next / previous class |

---

## Learn-first shortlist

If you're easing in, internalize these five before the rest:

1. `<C-p>` — open files
2. `<leader>fg` — search the project
3. `gd` and `K` — navigate and understand code
4. `<C-\>` — terminal
5. `<C-n>` — file tree

Everything else sticks as you reach for it.
