-- return {
--   "seblyng/roslyn.nvim",
--   ft = "cs",
--   ---@module 'roslyn.config'
--   ---@type RoslynNvimConfig
--   opts = {
--     -- your configuration comes here; leave empty for default settings
--   },
-- }
return {
  "seblyng/roslyn.nvim",
  enabled = false, -- instalar roslyn con mason
  config = function()
    ---@class LineRange
    ---@field line integer
    ---@field character integer

    ---@class EditRange
    ---@field start LineRange
    ---@field end LineRange

    ---@class TextEdit
    ---@field newText string
    ---@field range EditRange

    ---@param edit TextEdit
    local function apply_vs_text_edit(edit)
      local bufnr = vim.api.nvim_get_current_buf()
      local start_line = edit.range.start.line
      local start_char = edit.range.start.character
      local end_line = edit.range["end"].line
      local end_char = edit.range["end"].character

      local newText = string.gsub(edit.newText, "\r", "")
      local lines = vim.split(newText, "\n")

      local placeholder_row = -1
      local placeholder_col = -1

      -- placeholder handling
      for i, line in ipairs(lines) do
        local pos = string.find(line, "%$0")
        if pos then
          lines[i] = string.gsub(line, "%$0", "", 1)
          placeholder_row = start_line + i - 1
          placeholder_col = pos - 1
          break
        end
      end

      vim.api.nvim_buf_set_text(bufnr, start_line, start_char, end_line, end_char, lines)

      if placeholder_row ~= -1 and placeholder_col ~= -1 then
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_cursor(win, { placeholder_row + 1, placeholder_col })
      end
    end
    require("roslyn").setup({
      filewatching = "roslyn",
      -- broad_search = false,
      config = {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
          },
          ["csharp|formating"] = {
            dotnet_organize_imports_on_format = true,
          },
        },
        capabilities = {
          textDocument = {
            _vs_onAutoInsert = { dynamicRegistration = false },
          },
        },
        handlers = {
          ["textDocument/_vs_onAutoInsert"] = function(err, result, _)
            if err or not result then
              return
            end
            apply_vs_text_edit(result._vs_textEdit)
          end,
        },
      },
    })
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
      pattern = "*",
      callback = function()
        local clients = vim.lsp.get_clients({ name = "roslyn" })
        if not clients or #clients == 0 then
          return
        end

        local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
        for _, buf in ipairs(buffers) do
          vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
        end
      end,
    })

    vim.api.nvim_create_autocmd("InsertCharPre", {
      pattern = "*.cs",
      callback = function()
        local char = vim.v.char

        if char ~= "/" then
          return
        end

        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        row, col = row - 1, col + 1
        local bufnr = vim.api.nvim_get_current_buf()
        local uri = vim.uri_from_bufnr(bufnr)

        local params = {
          _vs_textDocument = { uri = uri },
          _vs_position = { line = row, character = col },
          _vs_ch = char,
          _vs_options = { tabSize = 4, insertSpaces = true },
        }

        -- NOTE: we should send textDocument/_vs_onAutoInsert request only after buffer has changed.
        vim.defer_fn(function()
          vim.lsp.buf_request(bufnr, "textDocument/_vs_onAutoInsert", params)
        end, 1)
      end,
    })
  end,
}
