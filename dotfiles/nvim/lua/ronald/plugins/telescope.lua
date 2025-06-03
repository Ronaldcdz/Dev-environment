return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")
    local builtin = require("telescope.builtin")
    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })
    telescope.setup({
      defaults = {
        path_display = { "smart" },
        file_ignore_patterns = { "node_modules", ".git", "dist", "build", ".github", ".nuxt", "bin", "obj" },
        mappings = {
          i = {
            -- ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            -- ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
            ["<C-x>"] = actions.delete_buffer,
            ["<C-h>"] = actions.select_horizontal,
          },
        },
      },
      pickers = {
        colorscheme = {
          enable_preview = true, -- Habilita la previsualización del tema de color
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set("n", "<leader>,", builtin.buffers, { desc = "Fuzzy find buffers" })
    keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Fuzzy find git files" })
    -- keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Fuzzy find git status" })
    keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Find symbols on current file" })
    keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, { desc = "Find symbols on current project" })
    keymap.set("n", "<leader>cs", builtin.colorscheme, { desc = "Change colorscheme" })
    keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
    keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find vim marks" })
    keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Find files in quickfix list" })
    keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "Show LSP references" })
    keymap.set("n", "<leader>li", builtin.lsp_implementations, {
      desc = "Show LSP implementations",
    })
    keymap.set("n", "<leader>ld", builtin.lsp_definitions, {
      desc = "Show LSP definitions",
    })
    keymap.set("n", "<leader>ld", builtin.lsp_type_definitions, {
      desc = "Show LSP type definitions",
    })
    keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Show buffers diagnostics" })
  end,
}
