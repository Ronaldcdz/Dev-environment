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
		-- local lspconfig = require("lspconfig")

		-- vim.lsp.config.csharp_ls.setup({
		-- capabilities =
		--   capabilities,
		-- })
		vim.lsp.config("cssls", {
			capabilities = capabilities,
		})

		vim.lsp.enable("cssls")

		local vue_language_server_path = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

		local vue_plugin = {
			name = "@vue/typescript-plugin",
			location = vue_language_server_path,
			languages = { "vue" },
			configNamespace = "typescript",
		}
		vim.lsp.config("ts_ls", {

			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				"vue",
			},
			init_options = {
				plugins = {
					vue_plugin,
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
				javascript = {
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
		vim.lsp.enable("ts_ls")

		vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })

		local vue_ls_config = {}
		vim.lsp.config("vue_ls", vue_ls_config)
		vim.lsp.enable("vue_ls")

		vim.lsp.config("powershell_es", {
			bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
		})

		vim.lsp.config("emmet_ls", {

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
		vim.lsp.enable("emmet_ls")

		vim.lsp.config("lua_ls", {

			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		})
		vim.lsp.enable("lua_ls")

		-- Diagnósticos personalizados en la columna de signos
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
}
