return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    local lspconfig = require("lspconfig")

    lspconfig.ts_ls.setup({
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vim.fn.stdpath("data")
              .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
            -- .. "C:/Users/RonaldCadiz/scoop/persist/nodejs/bin/node_modules/@vue/language-server",
            languages = { "vue" },
          },
        },
      },
      settings = {
        typescript = {
          tsserver = { useSyntaxServer = false },
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    })
    lspconfig.vue_ls.setup({
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      init_options = {
        vue = { hybridMode = false },
        typescript = {
          tsdk = "C:/Users/RonaldCadiz/AppData/Local/nvim-data/mason/packages/vue-language-server/node_modules/typescript/lib",
        },
      },
      settings = {
        typescript = {
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            parameterTypes = {
              enabled = true,
              suppressWhenArgumentMatchesName = true,
            },
            variableTypes = { enabled = true },
          },
        },
      },
    })
    lspconfig.emmet_ls.setup({
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
        },
      },
    })

    -- Diagnósticos personalizados en la columna de signos
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Configuración de servidores LSP
  end,
}
