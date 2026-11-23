-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local augroup = vim.api.nvim_create_augroup("user_qol", { clear = true })

-- Writing a file into a directory that does not exist yet just works
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local file = vim.api.nvim_buf_get_name(args.buf)
    if file ~= "" then
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end
  end,
  desc = "Create missing parent directories on save",
})

-- Pick up files that an external tool (opencode, git, a formatter) rewrote on
-- disk, so buffers do not silently go stale while you are looking at them
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup,
  command = "checktime",
  desc = "Reload buffers changed on disk",
})

-- A gentler colorcolumn only where it helps, and no ruler noise in the status line
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "python", "rust", "lua", "typescript", "javascript", "go", "c", "cpp", "gdscript" },
  callback = function()
    vim.opt_local.colorcolumn = "100"
  end,
  desc = "Show a 100 column guide in code",
})
