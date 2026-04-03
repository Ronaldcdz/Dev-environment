local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment
keymap.set("n", "<C-aa>", "<C-a>", { desc = "Increment number" }) -- increment

-- restart
vim.keymap.set("n", "<leader>rn", "<CMD>restart<CR>", { desc = "Restart Neovim (:restart)" })

-- Undotree
vim.keymap.set("n", "<leader>ut", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

-- Markdown Preview
vim.keymap.set("n", "<leader>pm", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Toggle Preview Markdown" })

-- Primeagen remaps to test
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", '"_dP')

-- Center while moving
vim.keymap.set("c", "<CR>", function()
	return vim.fn.getcmdtype() == "/" and "<CR>zzzv" or "<CR>"
end, { expr = true })
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set(
	{ "n", "v" },
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Substitute all current word" }
)

-----  OIL ------ ff
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Move Between Buffers
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })

keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true, desc = "Toggle diagnostics" })

vim.keymap.set("n", "<leader>cq", "<CMD>cexpr []<CR>", { desc = "Clean quick fix list" })

-- Resize windows/buffers with Ctrl+Cmd+arrow keys (macOS)
vim.keymap.set("n", "<C-S-Up>", "<cmd>resize +5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +5<CR>", { noremap = true, silent = true })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
