local luasnip = require("luasnip")

-- Saltar adelante / expandir
vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true })

-- Siguiente elección (Forward)
vim.keymap.set({ "i", "s" }, "<C-F>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end, { silent = true })

-- Elección anterior (Backward)
vim.keymap.set({ "i", "s" }, "<C-B>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(-1)
    end
end, { silent = true })
