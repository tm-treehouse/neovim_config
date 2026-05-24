-- ~/.config/nvim/lua/plugins/completion.lua
-- Autocompletion (your requested feature) via nvim-cmp. Pulls suggestions
-- from the LSP, snippets, buffer words, and file paths, with a popup UI that
-- behaves much like VS Code's IntelliSense.

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP completion source
      "hrsh7th/cmp-buffer",     -- words from the current buffer
      "hrsh7th/cmp-path",       -- filesystem paths
      {
        "L3MON4D3/LuaSnip",     -- snippet engine
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" }, -- prebuilt snippet set
      },
      "saadparwaiz1/cmp_luasnip", -- snippet completion source
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Load the community snippet collection (includes Python snippets).
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),  -- scroll the doc popup up
          ["<C-f>"] = cmp.mapping.scroll_docs(4),    -- scroll the doc popup down
          ["<C-Space>"] = cmp.mapping.complete(),    -- manually trigger completion
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- accept on Enter
          -- Tab / Shift-Tab to cycle items and jump through snippet placeholders.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
