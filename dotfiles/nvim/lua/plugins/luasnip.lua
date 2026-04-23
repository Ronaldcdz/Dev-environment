vim.pack.add({
	"https://github.com/L3MON4D3/LuaSnip",
})

local luasnip = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-K>", function()
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-J>", function()
	if luasnip.jumpable(-1) then
		luasnip.jump(-1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-L>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-H>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(-1)
	end
end, { silent = true })
