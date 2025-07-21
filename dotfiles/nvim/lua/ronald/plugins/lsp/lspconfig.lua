return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- "hrsh7th/nvim-cmp",
    "saghen/blink.cmp",
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
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    -- lspconfig.csharp_ls.setup({
    -- capabilities =
    --   capabilities,
    -- })
    lspconfig.cssls.setup({
      capabilities = capabilities,
    })

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        -- "vue",
      },
      -- init_options = {
      --   plugins = {
      --     {
      --       name = "@vue/typescript-plugin",
      --       location = vim.fn.stdpath("data")
      --         .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
      --       -- .. "C:/Users/RonaldCadiz/scoop/persist/nodejs/bin/node_modules/@vue/language-server",
      --       languages = { "vue", "typescript", "javascript" },
      --     },
      --   },
      -- },
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
    -- lspconfig.vue_ls.setup({
    --   capabilities = capabilities,
    --   filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    --   init_options = {
    --     vue = { hybridMode = false },
    --     typescript = {
    --       tsdk = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/typescript/lib",
    --     },
    --   },
    --   settings = {
    --     typescript = {
    --       inlayHints = {
    --         enumMemberValues = { enabled = true },
    --         functionLikeReturnTypes = { enabled = true },
    --         propertyDeclarationTypes = { enabled = true },
    --         parameterTypes = {
    --           enabled = true,
    --           suppressWhenArgumentMatchesName = true,
    --         },
    --         variableTypes = { enabled = true },
    --       },
    --     },
    --   },
    -- })

    local vue_language_server_path = vim.fn.stdpath("data")
      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
    local vue_plugin = {
      -- capabilities = capabilities,
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }
    local vtsls_config = {
      capabilities = capabilities,
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    }

    local vue_ls_config = {
      capabilities = capabilities,
      on_init = function(client)
        client.handlers["tsserver/request"] = function(_, result, context)
          local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
          if #clients == 0 then
            vim.notify("Could not find `vtsls` lsp client, `vue_ls` would not work without it.", vim.log.levels.ERROR)
            return
          end
          local ts_client = clients[1]

          local param = unpack(result)
          local id, command, payload = unpack(param)
          ts_client:exec_cmd({
            title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
            command = "typescript.tsserverRequest",
            arguments = {
              command,
              payload,
            },
          }, { bufnr = context.bufnr }, function(_, r)
            local response_data = { { id, r.body } }
            ---@diagnostic disable-next-line: param-type-mismatch
            client:notify("tsserver/response", response_data)
          end)
        end
      end,
    }
    -- nvim 0.11 or above
    vim.lsp.config("vtsls", vtsls_config)
    vim.lsp.config("vue_ls", vue_ls_config)
    vim.lsp.enable({ "vtsls", "vue_ls" })

    vim.lsp.config("powershell_es", {
      bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
    })

    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      filetypes = {
        "astro",
        "css",
        "eruby",
        "html",
        "htmlangular",
        "htmldjango",
        "javascriptreact",
        "less",
        "pug",
        "sass",
        "scss",
        "svelte",
        "templ",
        "typescriptreact",
        "vue",
      },
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
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
  end,
}
