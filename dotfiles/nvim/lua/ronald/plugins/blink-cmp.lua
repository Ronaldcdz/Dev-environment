return {
  "saghen/blink.cmp",
  enabled = true,
  dependencies = { "rafamadriz/friendly-snippets", "Kaiser-Yang/blink-cmp-avante" },
  version = "1.*",

  opts = {
    keymap = { preset = "default" },
    appearance = {
      nerd_font_variant = "mono",
    },
    signature = { enabled = true, window = { border = "single" } },
    completion = {
      menu = { border = "single" },
      documentation = { auto_show = true },
      accept = { auto_brackets = { enabled = true } },
    },

    sources = {
      default = { "avante", "lsp", "path", "snippets", "buffer", "easy-dotnet" },
      providers = {
        ["easy-dotnet"] = {
          name = "easy-dotnet",
          enabled = true,
          module = "easy-dotnet.completion.blink",
          score_offset = 10000,
          async = true,
        },
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
          },
        },
      },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
