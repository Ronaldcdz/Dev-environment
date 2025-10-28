return {
  "nvim-telescope/telescope.nvim",
  -- tag = "0.1.8",
  -- branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    -- telescope.setup({
    --   layout_strategy = "cursor",
    -- })

    local builtin = require("telescope.builtin")
    -- vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Find symbols on current file" })
    -- vim.keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, { desc = "Find symbols on current project" })
  end,
}
