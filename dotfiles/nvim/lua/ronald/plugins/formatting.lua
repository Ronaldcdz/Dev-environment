return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
      vue = { "prettier" },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 500 },
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    require("conform").setup({
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      -- if args.bang then
      --   -- FormatDisable! will disable formatting just for this buffer
      --   vim.b.disable_autoformat = true
      -- else
      --   vim.g.disable_autoformat = true
      -- end
      vim.b.disable_autoformat = true
      vim.g.disable_autoformat = true
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
    vim.keymap.set("n", "<leader>uf", function()
      if vim.b.disable_autoformat or vim.g.disable_autoformat then
        vim.cmd("FormatEnable")
        require("snacks.notify").info("Format Enabled")
      else
        vim.cmd("FormatDisable")
        require("snacks.notify").info("Format Disabled")
      end
    end, { desc = "Toggle [F]ormat" })

     vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      local range = nil
      if vim.fn.mode() == "v" or vim.fn.mode() == "v" or vim.fn.mode() == " ctrl-v" then
        local start_line, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
        local end_line, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
        local end_line_text = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, false)[1]
        range = {
          start = { start_line, 0 },
          ["end"] = { end_line, end_line_text:len() },
        }
      end
      require("conform").format({
        async = true,
        lsp_fallback = "fallback",
        range = range,
      })
    end, { desc = "Format buffer or selection" })
  end,
}
