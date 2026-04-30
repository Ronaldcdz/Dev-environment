-- Lazy load on first insert mode entry
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*",
	group = group,
	once = true,
	callback = function()
		require("blink.cmp").setup({
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			signature = { enabled = true, window = { border = "single" } },
			completion = {
				menu = { border = "single" },
				documentation = { auto_show = true },
				accept = { auto_brackets = { enabled = true } },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		})
	end,
})
