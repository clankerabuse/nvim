# Neovim

LazyVim on Omarchy, with the AI wired to the opencode go key
(`OPENCODE_GO_API_KEY` in `~/.hermes/.env`).

## Layout

- `lazyvim.json` — the LazyVim extras that are switched on
- `lua/config/` — options, keymaps, autocmds, remote clipboard
- `lua/plugins/ai.lua` — minuet (inline completions) and CodeCompanion (chat,
  inline edits, prompt library, opencode CLI agent)
- `lua/plugins/editor.lua` — undo tree, colour picker, diffview
- `lua/plugins/lang.lua` — masonry: parsers, tools, formatters, linters
- `lua/plugins/ui.lua` — snacks, neo-tree and bufferline polish
- `prompts/` — CodeCompanion prompt library (markdown)

Omarchy owns `lua/plugins/theme.lua` and rewrites it when the desktop theme
changes; everything else here is safe to edit.

## AI

| Key | What it does |
| --- | --- |
| `<leader>ac` | toggle the chat buffer |
| `<leader>aa` | action palette (prompts, agents, tools) |
| `<leader>ai` | inline edit of the selection |
| `<leader>an` | new chat |
| `<leader>a.` | add the selection to the chat as context |
| `<leader>ar` / `<leader>aR` | review working tree / branch |
| `<leader>aC` | open the opencode CLI agent in a terminal |
| `<leader>aT` | toggle inline completions |
| `<a-l>` / `<a-h>` / `<a-k>` | accept completion / one line / N lines |
| `<a-]>` / `<a-[>` / `<a-e>` | next / previous / dismiss completion |

Both plugins talk to `https://opencode.ai/zen/go` with
`deepseek-v4.1-flash` by default. The model list is in `MODEL` / `MODELS` at the
top of `lua/plugins/ai.lua`; pick another with `ga` inside a chat buffer.

Requests must carry an `x-opencode-session` header — the go relay rejects
anything without one. Both plugins add it; keep that in place if you change the
adapter.

Slash prompts: `:CodeCompanion /explain`, `/tests`, `/review`, `/refactor`,
`/commit`.

## Notes

- `vim.g.autoformat` stays off; format on demand with `<leader>cf`.
- GDScript gets treesitter, `gdformat` and `gdlint`, but no LSP: Neovim's
  `gdscript` server only speaks to a running Godot editor on port 6005.
- If `cargo` is broken for you, that is mise's global Rust shim, not this
  config — see `mise use -g rust@stable`.
