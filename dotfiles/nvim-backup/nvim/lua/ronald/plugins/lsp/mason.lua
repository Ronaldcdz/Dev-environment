return {
	"mason-org/mason.nvim",
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		ensure_installed = {
			"eslint_d",
			"prettier", -- prettier formatter
			"prettierd", -- prettier formatter
			"pylint",
			"isort", -- python formatter
		},
	},
}
