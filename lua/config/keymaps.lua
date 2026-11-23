-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Clear the search highlight with <esc>, the way every other editor does
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Keep the cursor in the middle of the screen for jumps and scrolling
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "<c-d>", "<c-d>zz", { desc = "Half page down (centered)" })
map("n", "<c-u>", "<c-u>zz", { desc = "Half page up (centered)" })
map("v", "<c-d>", "<c-d>zz", { desc = "Half page down (centered)" })
map("v", "<c-u>", "<c-u>zz", { desc = "Half page up (centered)" })

-- Copy paths without leaving the keyboard
map("n", "<leader>yf", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied absolute path" })
end, { desc = "Yank absolute path" })
map("n", "<leader>yr", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied relative path" })
end, { desc = "Yank relative path" })
map("n", "<leader>yn", function()
  local name = vim.fn.expand("%:t")
  vim.fn.setreg("+", name)
  vim.notify(name, vim.log.levels.INFO, { title = "Copied file name" })
end, { desc = "Yank file name" })

-- Which-key group headers for the groups this config adds to
require("which-key").add({
  { "<leader>a", group = "ai" },
  { "<leader>uu", group = "undo" },
  { "<leader>gv", group = "diffview" },
})
