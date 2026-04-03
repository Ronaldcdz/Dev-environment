require("conform").setup({

	format_after_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { lsp_format = "fallback" }
	end,

	-- Define your formatters
	formatters_by_ft = {
		-- Lenguajes web: Biome primero, luego el resto (prettierd, prettier)
		javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
		typescript = { "biome", "prettier", stop_after_first = true },
		javascriptreact = { "biome", "prettier", stop_after_first = true },
		typescriptreact = { "biome", "prettier", stop_after_first = true },
		svelte = { "prettier" }, -- Biome no soporta Svelte
		css = { "biome", "prettier", stop_after_first = true },
		html = { "biome", "prettier", stop_after_first = true },
		json = { "biome", "prettier", stop_after_first = true },
		yaml = { "prettier" }, -- Biome no soporta YAML
		markdown = { "prettier" }, -- Biome no soporta Markdown
		lua = { "stylua" },
		python = { "isort", "black" },
		vue = { "prettier" }, -- Biome no soporta Vue
	},
	-- Set default options
	default_format_opts = {
		lsp_format = "fallback",
	},
	-- Customize formatters (opcional, puedes añadir configuración para biome si lo necesitas)
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
		-- Ejemplo de configuración adicional para biome (opcional)
		-- biome = {
		--     command = "biome",
		--     args = { "format", "--stdin-file-path", "$FILENAME" },
		-- },
	},
})
vim.api.nvim_create_user_command("FormatDisable", function(args)
	-- if args.bang then
	--   -- FormatDisable! will disable formatting just for this buffer
	--   vim.b.disable_autoformat = true
	-- else
	--   vim.g.disable_autoformat = true
	-- end
	vim.b.disable_autoformat = true
	vim.g.disable_autoformat = true
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})
vim.keymap.set("n", "<leader>uf", function()
	if vim.b.disable_autoformat or vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
		require("snacks.notify").info("Format Enabled")
	else
		vim.cmd("FormatDisable")
		require("snacks.notify").info("Format Disabled")
	end
end, { desc = "Toggle [F]ormat" })

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	local range = nil
	if vim.fn.mode() == "v" or vim.fn.mode() == "v" or vim.fn.mode() == " ctrl-v" then
		local start_line, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
		local end_line, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
		local end_line_text = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1]
		range = {
			start = { start_line, 0 },
			["end"] = { end_line, end_line_text:len() },
		}
	end
	require("conform").format({
		async = true,
		lsp_fallback = true,
		range = range,
	})
end, { desc = "Format buffer or selection" })
