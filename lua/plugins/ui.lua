return {
  -- ~ snacks: the picker, dashboard and notifier LazyVim already wires up ~
  {
    "folke/snacks.nvim",
    opts = {
      -- foot speaks neither the kitty graphics protocol nor sixel, so leave
      -- image rendering off rather than letting it fall back to text art
      image = { enabled = false },
      notifier = {
        timeout = 3000,
        width = { min = 40, max = 0.4 },
      },
      dashboard = {
        preset = {
          header = table.concat({
            "",
            "   ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
            "   ████╗  ██║██║   ██║██║████╗ ████║",
            "   ██╔██╗ ██║██║   ██║██║██╔████╔██║",
            "   ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "   ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "   ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
            "",
          }, "\n"),
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      picker = {
        sources = {
          explorer = { hidden = true, ignored = true },
        },
      },
    },
  },

  -- ~ neo-tree: follow the buffer, stay narrow, open files without prompt ~
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
      },
      window = { width = 32 },
    },
  },

  -- ~ bufferline: keep the tab bar honest about diagnostics ~
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_icons = true,
        indicator = { style = "underline" },
        separator_style = "thin",
      },
    },
  },
}
