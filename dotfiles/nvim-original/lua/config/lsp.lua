vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason").setup({
	ensure_installed = {
		"prettier", -- prettier formatter
	},
})

require("mason-lspconfig").setup({
	automatic_enable = false,
	ensure_installed = {
		"vtsls",
		"html",
		"cssls",
		"tailwindcss",
		"lua_ls",
		"emmet_ls",
		"jsonls",
		"oxlint",
		"biome",
		"prettier",
		"vue_ls", -- era "volar"
		"stylua", -- lua formatter
	},
})

local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local default_keymaps = {
	{ keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code Actions" },
	{
		keys = "<leader>cl",
		func = function()
			if vim.fn.exists(":LspOxlintFixAll") > 0 then
				vim.cmd("LspOxlintFixAll")
			elseif vim.fn.exists(":LspEslintFixAll") > 0 then
				vim.cmd("LspEslintFixAll")
			else
				vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll" } } })
			end
		end,
		desc = "LSP Fix All",
	},
	{ keys = "<leader>cr", func = vim.lsp.buf.rename, desc = "Rename" },
	{ keys = "gd", func = vim.lsp.buf.definition, desc = "Goto Definition" },
	{ keys = "K", func = vim.lsp.buf.hover, desc = "Hover" },
	{ keys = "<leader>k", func = vim.lsp.buf.hover, desc = "Hover Documentation" },
}

-- Autocmd LspAttach (mantengo tu lógica original)
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp_attach"),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buf = args.buf
		if not client then
			return
		end

		-- Inlay hints
		if client:supports_method("textDocument/inlayHints") then
			vim.lsp.inlay_hint.enable(true, { bufnr = buf })

			if not vim.b[buf].inlay_hints_autocmd_set then
				vim.api.nvim_create_autocmd("InsertEnter", {
					buffer = buf,
					callback = function()
						vim.lsp.inlay_hint.enable(false, { bufnr = buf })
					end,
				})
				vim.api.nvim_create_autocmd("InsertLeave", {
					buffer = buf,
					callback = function()
						vim.lsp.inlay_hint.enable(true, { bufnr = buf })
					end,
				})
				vim.b[buf].inlay_hints_autocmd_set = true
			end
		end

		for _, km in ipairs(default_keymaps) do
			if not km.has or client.server_capabilities[km.has] then
				vim.keymap.set(
					km.mode or "n",
					km.keys,
					km.func,
					{ buffer = buf, desc = "LSP: " .. km.desc, nowait = km.nowait }
				)
			end
		end
	end,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.lsp.enable({
	"eslint",
	"oxlint",
	"biome",
	"lua_ls",
	"jsonls",
	"cssls",
	"vue_ls",
	"emmet_ls",
})

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
