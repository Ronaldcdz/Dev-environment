return {
	"nvim-lualine/lualine.nvim",
	event = "ColorScheme",
	enabled = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				--- @usage 'rose-pine' | 'rose-pine-alt'
				theme = "rose-pine",
			},
		})
	end,
}
