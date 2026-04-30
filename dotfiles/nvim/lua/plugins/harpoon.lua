local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED
local normalize_list = function(t)
  local normalized = {}
  for _, v in pairs(t) do
    if v ~= nil then
      table.insert(normalized, v)
    end
  end
  return normalized
end

vim.keymap.set("n", "<leader>hh", function()
  Snacks.picker({
    finder = function()
      local file_paths = {}
      local list = normalize_list(harpoon:list().items)
      for i, item in ipairs(list) do
        table.insert(file_paths, { text = item.value, file = item.value })
      end
      return file_paths
    end,
    win = {
      input = {
        keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
      },
      list = {
        keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
      },
    },
    actions = {
      harpoon_delete = function(picker, item)
        local to_remove = item or picker:selected()
        harpoon:list():remove({ value = to_remove.text })
        harpoon:list().items = normalize_list(harpoon:list().items)
        picker:find({ refresh = true })
      end,
    },
  })
end, { desc = "Harpoon List" })
vim.keymap.set("n", "<leader>ha", function()
  harpoon:list():add()
end, { desc = "Add file to harpoon" })

vim.keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end, { desc = "Select harpoon file 1" })

vim.keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end, { desc = "Select harpoon file 2" })

vim.keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end, { desc = "Select harpoon file 3" })

vim.keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end, { desc = "Select harpoon file 4" })

vim.keymap.set("n", "<leader>5", function()
  harpoon:list():select(5)
end, { desc = "Select harpoon file 5" })

vim.keymap.set("n", "<leader>6", function()
  harpoon:list():select(6)
end, { desc = "Select harpoon file 6" })

vim.keymap.set("n", "<leader>7", function()
  harpoon:list():select(7)
end, { desc = "Select harpoon file 7" })

vim.keymap.set("n", "<leader>8", function()
  harpoon:list():select(8)
end, { desc = "Select harpoon file 8" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function()
  harpoon:list():prev()
end, { desc = "Select harpoon previous file" })
vim.keymap.set("n", "<leader>hn", function()
  harpoon:list():next()
end, { desc = "Select harpoon next file" })
