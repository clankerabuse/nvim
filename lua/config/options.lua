-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.g.autoformat = false

-- Mason's tools live outside the shell PATH until the plugin loads, so put them
-- there up front: conform, nvim-lint and dap all look tools up at first use
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- ~ Quality of life ~
vim.o.confirm = true -- ask instead of failing on :q with unsaved buffers
vim.opt.undofile = true -- persistent undo across sessions
vim.opt.autoread = true -- let :checktime reload buffers an agent rewrote on disk
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.timeoutlen = 350
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 8
vim.opt.pumheight = 12
vim.opt.pumblend = 0
vim.opt.splitkeep = "screen"
vim.opt.winminwidth = 5
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes:2" -- no text shifting when signs come and go
vim.opt.winborder = "rounded" -- every floating window in Neovim gets a border
vim.opt.title = true

-- Whitspace and wrapping
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "…", precedes = "…" }
vim.opt.linebreak = true
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }

-- Sessions keep more of the editor state
vim.opt.sessionoptions = "buffers,curdir,folds,globals,help,tabpages,terminal,winsize,localoptions"

-- Diagnostics: compact inline text, float on a keymap, jump into the list
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = true },
  virtual_text = { spacing = 2, prefix = "icons" },
  jump = { float = true },
})

-- Show every diagnostic for the current line, in place, without flooding the buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_inlay_hints", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

-- Editor behavior that reads better for prose and code alike
vim.opt.formatoptions = "jcroqlnt"
vim.opt.inccommand = "split"
