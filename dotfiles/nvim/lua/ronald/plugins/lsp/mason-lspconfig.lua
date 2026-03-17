return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"ts_ls",
			"html",
			"cssls",
			"tailwindcss",
			"lua_ls",
			"emmet_ls",
			"pyright",
			"vue_ls", -- era "volar"
			-- "roslyn", -- instalar manualmente con :MasonInstall roslyn
			-- "csharp_ls",
			"powershell_es",
			-- "vtsls",
			"markdown_oxide",
			"stylua", -- lua formatter
			"eslint",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
