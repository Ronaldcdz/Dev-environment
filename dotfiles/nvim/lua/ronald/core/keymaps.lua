vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment
keymap.set("n", "<C-aa>", "<C-a>", { desc = "Increment number" }) -- increment

-- Undotree
vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Open Undo tree" })

-- Markdown Preview
vim.keymap.set("n", "<leader>pm", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Toggle Preview Markdown" })

-- Typst Preview
vim.keymap.set("n", "<leader>pt", "<CMD>TypstPreviewToggle<CR>", { desc = "Toggle Preview Typst" })

-- Primeagen remaps to test
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", '"_dP')

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
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Substitute all current word" }
)

-- vim.opt.guicursor = ""
vim.opt.incsearch = true

-----  OIL ------ ff
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- disabling defaults vim commands
-- vim.keymap.set("n", "<C-h>", "<nop>")
-- vim.keymap.set("n", "C-t", "<nop>")
-- vim.keymap.set("n", "C-n", "<nop>")
-- vim.keymap.set("n", "C-s", "<nop>")
-- vim.keymap.del("n", "<c-h>")
-- go out of insert mode

-- vim.keymap.set("i", "ht", "<ESC>")

-- move between buffers
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })

keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

vim.keymap.set("n", "<leader>cq", "<CMD>cexpr []<CR>", { desc = "Clean quick fix list" })
-- vim.keymap.set("i", "<C-v>", "<C-r>*", { desc = "Pegar (portapapeles) en Modo Inserción" })
vim.keymap.set("n", "<leader>uC", "<CMD>SmearCursorToggle<CR>", { desc = "Toggle Smear Cursor" })

-- LUA DEFAULTS KEYMAPS OVERRIDES BY PLUGIN LSPSAGA
vim.keymap.set("n", "glp", "<cmd>Lspsaga peek_definition<CR>")
vim.keymap.set("n", "glP", "<cmd>Lspsaga peek_type_definition<CR>")
vim.keymap.set("n", "gra", "<CMD>Lspsaga code_action<CR>", {
	desc = "Lspsaga code action",
})
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", {
	desc = "Lspsaga Hover doc",
})
vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>", {
	desc = "Lspsaga go to definition",
})
vim.keymap.set("n", "gy", "<cmd>Lspsaga goto_type_definition<CR>", {
	desc = "Lspsaga go to type definition",
})

vim.keymap.set("n", "gri", "<cmd>Lspsaga finder imp<CR>", {
	desc = "Lspsaga implementation",
})
vim.keymap.set("n", "grn", "<cmd>Lspsaga rename<CR>", {
	desc = "Lspsaga rename",
})
vim.keymap.set("n", "gli", "<cmd>Lspsaga incoming_calls<CR>")
vim.keymap.set("n", "glo", "<cmd>Lspsaga outgoing_calls<CR>")
