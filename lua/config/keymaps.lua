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

-- opencode inside the editor: <leader>ao hands the current file (or selection)
-- to the opencode CLI and watches the buffer update as it writes; <leader>aO
-- opens a plain interactive session for the project
local oc = require("opencode")
map("n", "<leader>ao", function()
  oc.prompt()
end, { desc = "opencode: edit this file" })
map("v", "<leader>ao", function()
  local lines = vim.fn.getline("'<", "'>")
  vim.cmd("normal! \27")
  oc.prompt(table.concat(lines, "\n"))
end, { desc = "opencode: edit this selection" })
map("n", "<leader>aO", oc.tui, { desc = "opencode: interactive session" })
vim.api.nvim_create_user_command("Opencode", function(args)
  -- :Opencode! approves tool permissions for one run; the default refuses shell
  oc.ask(args.args, nil, { auto = args.bang })
end, { nargs = "*", bang = true, desc = "Ask opencode to edit the current file (:Opencode! auto-approves)" })

-- A cheatsheet for the AI keys: which-key cannot show insert-mode maps, so the
-- most important ones (accepting a completion) would otherwise be invisible
map("n", "<leader>a?", function()
  local lines = {
    "opencode go AI",
    "",
    "inline completion   <a-l> accept  <a-h> one line  <a-k> n lines",
    "                    <a-]> next    <a-[> previous  <a-e> dismiss",
    "                    <leader>aT toggle",
    "",
    "chat                <leader>ac toggle  <leader>aa palette  <leader>an new",
    "                    <leader>ai inline edit  <leader>a. add selection",
    "                    <leader>ar review tree  <leader>aR review branch",
    "",
    "opencode agent      <leader>ao edit file or selection, live reload",
    "                    <leader>aO interactive session",
    "                    :Opencode <task>  :Opencode! auto-approves",
    "                    shell: nvim-safe profile, read-only only",
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width + 2,
    height = #lines,
    row = math.max(0, math.floor((vim.o.lines - #lines) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2) - 1),
    title = " AI ",
  })
  for _, key in ipairs({ "q", "<esc>" }) do
    map("n", key, function()
      pcall(vim.api.nvim_win_close, win, true)
    end, { buffer = buf })
  end
end, { desc = "AI cheatsheet" })

-- Which-key group headers for the groups this config adds to
require("which-key").add({
  { "<leader>a", group = "ai" },
  { "<leader>uu", group = "undo" },
  { "<leader>gv", group = "diffview" },
})
