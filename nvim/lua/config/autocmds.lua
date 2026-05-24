-- ~/.config/nvim/lua/config/autocmds.lua
-- Foundational autocommands. Each is wrapped in its own augroup so re-sourcing
-- this file doesn't stack duplicate handlers.

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Briefly highlight text after yanking it. Confirms visually what you copied.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    -- vim.hl is the current API; vim.highlight is the pre-0.11 name.
    (vim.hl or vim.highlight).on_yank({ timeout = 200 })
  end,
})

-- When reopening a file, jump to the last cursor position. Skips commit
-- messages (where you always want to start at the top) and invalid lines.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create missing parent directories when saving a new file, so `:w` to a
-- not-yet-existing folder just works instead of erroring.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return -- skip URLs / non-file buffers (e.g. oil://, fugitive://)
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
