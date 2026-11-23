-- Language support beyond the LazyVim extras in lazyvim.json:
-- parsers, tools and formatters that the extras do not cover.
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- formatters and linters the extras do not bring in
        "gdtoolkit", -- gdformat + gdlint for GDScript
        "markdownlint",
        "prettier",
        "shellcheck",
        "shfmt",
        "stylua",
        "ruff",
        -- debug adapters used by the dap extras
        "codelldb",
        "debugpy",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "gdscript",
        "gitcommit",
        "git_rebase",
        "html",
        "ini",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "ssh_config",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gdscript = { "gdformat" },
        python = { "ruff_organize_imports", "ruff_format" },
        markdown = { "prettier", "markdownlint" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        gdscript = { "gdlint" },
        markdown = { "markdownlint" },
      },
    },
  },
}
