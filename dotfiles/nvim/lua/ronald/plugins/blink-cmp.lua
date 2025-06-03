return {
  "saghen/blink.cmp",
  enabled = true,
  dependencies = { "rafamadriz/friendly-snippets" },

  version = "1.*",

  opts = {

    completion = { documentation = { auto_show = true }, accept = { auto_brackets = { enabled = true } } },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
