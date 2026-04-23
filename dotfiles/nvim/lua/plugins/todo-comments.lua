vim.pack.add({
	"https://github.com/folke/todo-comments.nvim",
})

local todo_comments = require("todo-comments")

-- Configuración con keywords coherentes
todo_comments.setup({
	keywords = {
		-- BUG: reporta errores conocidos (usa grupo de error estándar)
		BUG = {
			icon = "🐛 ", -- ícono de bicho
			color = "error", -- se vincula a DiagnosticError
			alt = { "BUGFIX", "FIXBUG" }, -- alias adicionales
		},
		-- CHECK: revisiones o verificaciones pendientes (usa grupo de advertencia)
		CHECK = {
			icon = "✓ ", -- check o visto
			color = "warning", -- se vincula a DiagnosticWarn
			alt = { "VERIFY", "REVIEW" },
		},
		-- El resto de keywords (TODO, FIX, HACK, PERF, NOTE, TEST, WARN) conservan sus valores predeterminados
	},
})

-- Navegación entre comentarios TODO/FIX/etc
vim.keymap.set("n", "]t", function()
	todo_comments.jump_next()
end, { desc = "Siguiente comentario TODO" })

vim.keymap.set("n", "[t", function()
	todo_comments.jump_prev()
end, { desc = "Anterior comentario TODO" })

-- Búsqueda con Snacks (requiere Snacks.nvim instalado)
vim.keymap.set("n", "<leader>st", function()
	require("snacks").picker.todo_comments()
end, { desc = "Buscar todos los TODOs" })

vim.keymap.set("n", "<leader>sT", function()
	require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "BUG" } })
end, { desc = "Buscar TODO/FIX/FIXME/BUG" })
