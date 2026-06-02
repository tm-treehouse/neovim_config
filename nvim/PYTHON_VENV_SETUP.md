# Getting started: Python venv awareness with uv & poetry

This guide covers two complementary approaches for making pyright (and ruff)
aware of your project's virtualenv, so package imports stop being flagged as
missing:

- **Approach A** — drop a `pyrightconfig.json` (or `pyproject.toml` snippet) at
  the project root. Declarative, no Neovim involved, works in every editor that
  speaks LSP. Best for projects you work on repeatedly.
- **Approach C** — the `venv-selector.nvim` plugin lets you pick a venv from
  inside Neovim with `:VenvSelect`. pyright re-attaches against it
  automatically. Best for trying out a new project, switching environments
  mid-session, or anything you haven't set up a config file for.

Use them together: the config file makes the common case zero-effort; the
plugin handles everything else without restarting.

---

## Why pyright needs help

Pyright doesn't introspect `uv`, `poetry`, or `pdm`. It looks for a Python
interpreter path. If your `$VIRTUAL_ENV` isn't set when you launch nvim — which
is the usual case if you `nvim .` without activating the venv first — pyright
falls back to the system Python and reports every project dependency as
missing.

The fix is to tell pyright which interpreter to use. There's no automatic
package-manager magic; both approaches below are different ways to deliver the
same single piece of information: *"use this interpreter."*

---

## Approach A: per-project `pyrightconfig.json`

### Step 1 — find your venv

**uv** (uses an in-project `.venv` by default):

    uv sync                       # if you haven't already
    uv run python -c "import sys; print(sys.executable)"
    # → /path/to/project/.venv/bin/python

**poetry** (cache is elsewhere unless you configured in-project venvs):

    poetry env info --path
    # → /Users/you/Library/Caches/pypoetry/virtualenvs/myproj-AbC123-py3.12

Tip: if you want poetry to keep venvs *inside* the project (recommended for
editor tooling), set it once: `poetry config virtualenvs.in-project true`. New
envs will land at `./.venv/`.

### Step 2 — create `pyrightconfig.json`

At the project root, create a file called `pyrightconfig.json`:

```json
{
  "venvPath": ".",
  "venv": ".venv",
  "pythonVersion": "3.12",
  "typeCheckingMode": "basic"
}
```

`venvPath` is the directory that *contains* the venv; `venv` is its name.
Combined, pyright resolves the interpreter at `./.venv/bin/python`. For poetry
with the default external cache, point `venvPath` at the cache directory:

```json
{
  "venvPath": "/Users/you/Library/Caches/pypoetry/virtualenvs",
  "venv": "myproj-AbC123-py3.12",
  "pythonVersion": "3.12"
}
```

Either way, restart Neovim (or `:LspRestart`) once after creating the file —
pyright reads it on attach.

### Step 3 (optional) — same thing in `pyproject.toml`

If you prefer one config file per project, put the same settings under
`[tool.pyright]`:

```toml
[tool.pyright]
venvPath = "."
venv = ".venv"
pythonVersion = "3.12"
typeCheckingMode = "basic"
```

Pyright reads `pyproject.toml` when there's no `pyrightconfig.json`.

### Step 4 — commit it (or don't)

`pyrightconfig.json` is editor-agnostic — your VS Code teammates benefit from
the same file. Most teams commit it. The poetry-cache variant has user-specific
paths, so either gitignore it or use the in-project venv layout to keep it
portable.

---

## Approach C: `venv-selector.nvim`

### Step 1 — install

This config now ships venv-selector in `lua/plugins/venv.lua`. After applying
the patch, run:

    :Lazy sync

Restart Neovim once so the new commands and keymaps register.

### Step 2 — pick a venv

In any Python project:

    :VenvSelect

A picker (telescope) lists every venv it found. Choose one with `<CR>`.
Pyright restarts immediately against that interpreter. Two keymaps are wired
in:

| Key            | Action                                |
|----------------|---------------------------------------|
| `<leader>cv`   | `:VenvSelect`     — pick a venv       |
| `<leader>cV`   | `:VenvSelectCached` — reuse last pick |

### Step 3 — let it remember

The plugin caches your choice per directory. The second time you open the
project, just `<leader>cV` (or run `:VenvSelectCached`) and the same venv is
activated automatically, no picker needed.

### Where it looks

By default the plugin searches the locations uv and poetry use, plus a few
common conventions:

- `./.venv` and `./venv` in the project (uv default; poetry with
  `virtualenvs.in-project true`)
- `~/.cache/pypoetry/virtualenvs/` and the macOS equivalent
  `~/Library/Caches/pypoetry/virtualenvs/`
- `~/.virtualenvs/` (pyenv-virtualenv, virtualenvwrapper)

This config also adds a small extra search hook for any custom `~/.virtualenvs`
layout. If your team stashes venvs somewhere unusual, extend the `search` table
in `lua/plugins/venv.lua` to point at it.

---

## Which one fires when?

If both are present, pyright resolves the interpreter in this order:

1. Explicit `python.pythonPath` set by venv-selector at runtime (Approach C
   wins when active).
2. `pyrightconfig.json` / `[tool.pyright]` in the project root (Approach A).
3. `$VIRTUAL_ENV` if you launched nvim from an activated shell.
4. System Python (the "everything is missing" fallback).

So a typical workflow looks like: drop a `pyrightconfig.json` in the project
once, and from then on pyright resolves the venv automatically every time you
open the project. If you spin up a throwaway environment or switch between two
venvs, use `:VenvSelect` to override at runtime.

---

## Verifying it worked

Open a Python file in the project and run `:LspInfo`. The pyright section
should list a `pythonPath` pointing at your venv's `python` (not the system
one). Hover (`K`) on an imported third-party symbol — you should see real
documentation rather than a "could not be resolved" diagnostic.

If imports are still flagged red:

- Did you actually install dependencies? `uv sync` or `poetry install`.
- Is the venv path right? `python -c "import <package>"` from a shell with
  the venv activated should succeed.
- Restart the language server: `:LspRestart`. Pyright caches aggressively.
- `:checkhealth vim.lsp` shows what configuration pyright actually loaded.

---

## What about ruff?

Ruff finds your project automatically (it looks for `pyproject.toml` and
follows tool config there). No venv path needed; the linter rules don't care
which interpreter you use. Both approaches above only affect pyright.

---

## Summary

| Situation                                  | Use          |
|--------------------------------------------|--------------|
| Project you work on regularly              | A — config file |
| One-off project / quick exploration        | C — `:VenvSelect` |
| Team-shared project (works in VS Code too) | A — config file |
| Switching between two venvs mid-session    | C — `:VenvSelect` |
| Most projects                              | A + C together |

The combination is genuinely low-friction once set up: config file in the
projects you care about, the plugin as the runtime escape hatch for everything
else.
