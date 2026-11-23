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
| `<leader>ao` | hand the file (or selection) to the opencode agent; edits land live |
| `<leader>aO` | interactive opencode session in a terminal split |
| `<leader>a?` | cheatsheet of every AI key |
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

`<leader>ao` saves the buffer and runs `opencode run` in the project root in a
terminal split, and polls the file's mtime while it works: every write reloads
the buffer (and gitsigns marks it), so the edit appears as it happens.
`autoread` is on for the same reason. Any other open file the agent touched is
reloaded when the run exits.

### Agent permissions

The run is pinned to the `nvim-safe` agent
(`~/.config/opencode/agents/nvim-safe.md`, copy in
`contrib/opencode/agents/`): it may edit files and run read-only
commands (`git status/diff/log/show/branch`, `ls`, `rg`, `fd`, `pwd`), and asks
before anything else. `opencode run` is non-interactive, so an "ask" becomes a
refusal — the agent edits code but cannot run arbitrary shell.

`--auto` is the opt-in for the riskier behaviour, where the agent approves its
own commands for itself:

- `vim.g.opencode_auto_approve = true` in `lua/config/options.lua` — always on
- `:Opencode! <task>` — one run

Even then the hard denies stay denied (`sudo`, `rm -rf`, `git push`). Without
the agent file the plugin notifies you and runs with opencode's defaults, which
are permissive.

`<leader>aO` opens a plain interactive `opencode` session; the top-level CLI
takes no `--agent` flag, so that one starts on the build agent — switch agents
inside the session.

## Notes

- `vim.g.autoformat` stays off; format on demand with `<leader>cf`.
- GDScript gets treesitter, `gdformat` and `gdlint`, but no LSP: Neovim's
  `gdscript` server only speaks to a running Godot editor on port 6005.
- If `cargo` is broken for you, that is mise's global Rust shim, not this
  config — see `mise use -g rust@stable`.
