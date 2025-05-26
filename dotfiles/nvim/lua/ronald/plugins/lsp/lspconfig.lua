return {
  "neovim/nvim-lspconfig",
  -- "mason-org/mason-lspconfig.nvim",
  version = "^1.0.0",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    {
      "folke/neodev.nvim",
      opts = {},
    },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    -- Esta en snacks.lua
    -- Configurar keybinds para LSP
    -- vim.api.nvim_create_autocmd("LspAttach", {
    --   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    --   callback = function(ev)
    --     local opts = { buffer = ev.buf, silent = true }
    --     local mappings = {
    --       -- { "n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
    --       -- { "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
    --       -- { "n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
    --       -- { "n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
    --       -- { "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
    --       { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
    --       { "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
    --       -- { "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
    --       { "n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
    --       { "n", "[d", vim.diagnostic.jump({ count = -1, float = true }), "Go to previous diagnostic" },
    --       { "n", "]d", vim.diagnostic.jump({ count = 1, float = true }), "Go to next diagnostic" },
    --       { "n", "K", vim.lsp.buf.hover, "Show documentation under cursor" },
    --       { "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
    --     }
    --     for _, map in ipairs(mappings) do
    --       opts.desc = map[4]
    --       keymap.set(map[1], map[2], map[3], opts)
    --     end
    --   end,
    -- })

    local capabilities = cmp_nvim_lsp.default_capabilities()
    -- Diagnósticos personalizados en la columna de signos
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Configuración de servidores LSP
    local servers = {
      volar = {
        capabilities = capabilities,
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
      },
      ts_ls = {
        capabilities = capabilities,
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
      },
      graphql = {
        capabilities = capabilities,
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      },
      emmet_ls = {
        capabilities = capabilities,
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      },
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      },
    }

    mason_lspconfig.setup_handlers({
      function(server_name)
        if servers[server_name] then
          lspconfig[server_name].setup(servers[server_name])
        else
          lspconfig[server_name].setup({ capabilities = capabilities })
        end
      end,
    })
  end,
}
-- }
