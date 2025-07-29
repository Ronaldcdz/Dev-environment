vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

vim.keymap.set("n", "<leader>rr", ":Roslyn restart<CR>", { desc = "Restart Roslyn Server" })
vim.keymap.set("n", "<leader>rt", ":Roslyn target<CR>", { desc = "Choose a solution" })
