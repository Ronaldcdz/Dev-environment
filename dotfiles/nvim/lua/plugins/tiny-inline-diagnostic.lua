require("tiny-inline-diagnostic").setup({
	preset = "modern",
})
vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
