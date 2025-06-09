return {
  "neovim/nvim-lspconfig",
  dependencies = {
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
    local lspconfig = require("lspconfig")

    -- lspconfig.csharp_ls.setup({
    --   capabilities = capabilities,
    -- })
    lspconfig.cssls.setup({
      capabilities = capabilities,
    })

    lspconfig.ts_ls.setup({
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
    })
    lspconfig.vue_ls.setup({
      capabilities = capabilities,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      init_options = {
        vue = { hybridMode = false },
        typescript = {
          -- tsdk = "C:/Users/RonaldCadiz/AppData/Local/nvim-data/mason/packages/vue-language-server/node_modules/typescript/lib",
          tsdk = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/typescript/lib",
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
      capabilities = capabilities,
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
    -- vim.api.nvim_create_autocmd("LspAttach", {
    --   callback = function(args)
    --     local bufnr = args.buf
    --     local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
    --
    --     local builtin = require("telescope.builtin")
    --
    --     vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    --     vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
    --     vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
    --     vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
    --     vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
    --     vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    --
    --     vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
    --     vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
    --     vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })
    --   end,
    -- })
    -- vim.api.nvim_create_autocmd("LspAttach", {
    --   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    --   callback = function(ev)
    --     local opts = { buffer = ev.buf, silent = true }
    --     local mappings = {
    --       { "n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
    --       { "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
    --       { "n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
    --       { "n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
    --       { "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
    --       { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
    --       { "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
    --       { "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
    --       { "n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
    --       { "n", "[d", vim.diagnostic.jump({ count = 1, float = true }), "Go to previous diagnostic" },
    --       { "n", "]d", vim.diagnostic.jump({ count = -1, float = true }), "Go to next diagnostic" },
    --       { "n", "K", vim.lsp.buf.hover, "Show documentation under cursor" },
    --       { "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
    --     }
    --     for _, map in ipairs(mappings) do
    --       opts.desc = map[4]
    --       vim.keymap.set(map[1], map[2], map[3], opts)
    --     end
    --   end,
    -- })
    -- vim.api.nvim_create_autocmd("LspAttach", {
    --   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    --   callback = function(ev)
    --     local opts = { buffer = ev.buf, silent = true }
    --
    --     local mappings = {
    --       { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
    --       { "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
    --       { "n", "<leader>dl", vim.diagnostic.open_float, "Show line diagnostics" },
    --       { "n", "[d", vim.diagnostic.jump({ count = 1, float = true }), "Go to previous diagnostic" },
    --       { "n", "]d", vim.diagnostic.jump({ count = -1, float = true }), "Go to next diagnostic" },
    --       { "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
    --       { "n", "K", vim.lsp.buf.hover, "Show documentation under cursor" },
    --     } -- La tabla 'mappings' se cierra aquí.
    --
    --     for _, map in ipairs(mappings) do
    --       opts.desc = map[4]
    --       vim.keymap.set(map[1], map[2], map[3], opts)
    --     end
    --   end,
    -- })
  end,
}
