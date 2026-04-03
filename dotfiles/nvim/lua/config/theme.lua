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

