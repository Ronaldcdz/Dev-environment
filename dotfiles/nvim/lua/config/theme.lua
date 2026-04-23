vim.pack.add({
	"https://github.com/rose-pine/neovim",
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/tiagovla/tokyodark.nvim",
	"https://github.com/catppuccin/nvim",
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/scottmckendry/cyberdream.nvim",
	"https://github.com/olimorris/onedarkpro.nvim",
})

require("rose-pine").setup({
	variant = "dawn",
	dark_variant = "moon",
	dim_inactive_windows = false,
	extend_background_behind_borders = true,
	enable = {
		terminal = true,
		legacy_highlights = true,
		migrations = true,
	},
	styles = {
		transparency = true,
	},
})
vim.cmd("colorscheme rose-pine")
