return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    ls.add_snippets("vue", {
      s("clg", {
        t("console.log(", i(1), t(")")),
      }),
    })
  end,
}
