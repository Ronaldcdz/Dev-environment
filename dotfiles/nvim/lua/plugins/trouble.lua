vim.pack.add({
	"https://github.com/folke/trouble.nvim",
})

local trouble = require("trouble")

-- Configuración (equivalente a `opts`)
trouble.setup({
	focus = true,
})

-- Comandos (equivalente a `cmd` y `keys`)
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Abrir diagnósticos del workspace" })
vim.keymap.set(
	"n",
	"<leader>xd",
	"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Abrir diagnósticos del documento" }
)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", { desc = "Abrir lista quickfix" })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Abrir lista de ubicaciones" })
vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<CR>", { desc = "Abrir TODOs en Trouble" })
