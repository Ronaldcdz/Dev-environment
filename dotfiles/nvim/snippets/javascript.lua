local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- Snippet: cl → console.log()
	s(
		"cl",
		fmt("console.log({})", {
			i(1, "mensaje"), -- placeholder inicial
		})
	),

	-- Snippet: clv → console.log con nombre de variable y valor (más avanzado)
	s(
		"clv",
		fmt("console.log('{}:', {})", {
			i(1, "variable"),
			i(2, "variable"), -- se repite el placeholder para escribir solo una vez
		})
	),

	-- Snippet: cld → console.log con formato de objeto (JSON.stringify)
	s(
		"cld",
		fmt("console.log(JSON.stringify({}, null, 2))", {
			i(1, "objeto"),
		})
	),
}
