return {
  -- ~ undo history as a tree you can actually see ~
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow", "UndotreeHide", "UndotreeFocus" },
    keys = {
      { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 35
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_DiffAutoOpen = 1
      -- relative timestamps read better when you come back to a file later
      vim.g.undotree_ShortIndicators = 1
    end,
  },

  -- ~ pick colors instead of guessing hex codes ~
  {
    "uga-rosa/ccc.nvim",
    cmd = { "CccPick", "CccConvert", "CccHighlighterToggle" },
    keys = {
      { "<leader>cC", "<cmd>CccPick<cr>", desc = "Color picker" },
      { "<leader>cP", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle color highlight" },
    },
    opts = {
      highlighter = {
        auto_enable = false, -- only when asked; keeps redraws cheap on big files
        lsp = true,
      },
    },
  },

  -- ~ diffs and history without leaving the editor ~
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gvo", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
      { "<leader>gvf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gvF", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal", winbar_info = true },
        file_history = { layout = "diff2_horizontal", winbar_info = true },
      },
      file_panel = { win_config = { width = 35 } },
    },
  },
}
