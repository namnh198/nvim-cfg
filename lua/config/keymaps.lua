-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- General
map({ "n", "i", "s", "x" }, "<C-a>", "gg<S-v>G", { desc = "selected all" })
map("x", "<leader>d", "y'o<Esc>p", { desc = "duplicate selected" })

-- Buffers
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Prev buffer" })
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Next buffer" })

-- Split windows
map("n", "ss", ":split<Return>", { desc = "split horizontal" })
map("n", "sv", ":vsplit<Return>", { desc = "split vertical" })

-- Copying file path
map("n", "<leader>cf", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied relative path:\n" .. path)
end, { desc = "copy relative path" })

map("n", "<leader>cF", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied absolute path:\n" .. path)
end, { desc = "copy absolute path", remap = true })

-- Formating
map({ "n", "v" }, "<leader>fm", function()
  LazyVim.format({ force = true })
end, { desc = "format" })
