-- Run the opencode CLI from inside Neovim and watch the files it edits.
--
-- opencode is already configured to talk to opencode go, so this spends the same
-- key the completion and chat plugins use. The integration is deliberately thin:
-- a terminal split streams the agent's output, and a poll on the file's mtime
-- reloads the buffer as it is written, so edits appear as they happen.
local M = {}

local function bufname(buf)
  return vim.api.nvim_buf_get_name(buf or vim.api.nvim_get_current_buf())
end

local function project_root(buf)
  local name = bufname(buf)
  if name == "" or vim.bo[buf].buftype ~= "" then
    return vim.fn.getcwd()
  end
  return vim.fs.root(buf, { ".git", "pyproject.toml", "Cargo.toml", "package.json", "go.mod" })
    or vim.fn.fnamemodify(name, ":p:h")
end

local function mtime(path)
  local stat = vim.uv.fs_stat(path)
  return stat and (stat.mtime.sec * 1e9 + stat.mtime.nsec) or nil
end

---Reload the buffer whenever the file changes on disk, until it goes quiet.
local function watch(buf, path)
  local timer = assert(vim.uv.new_timer())
  local last = mtime(path)
  local quiet = 0
  timer:start(
    250,
    250,
    vim.schedule_wrap(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        timer:stop()
        timer:close()
        return
      end
      local now = mtime(path)
      if now and now ~= last then
        last = now
        quiet = 0
        if vim.bo[buf].modified then
          vim.notify("File changed on disk, buffer has unsaved edits", vim.log.levels.WARN)
        else
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! checktime")
          end)
          pcall(function()
            require("gitsigns").refresh(buf)
          end)
        end
      else
        quiet = quiet + 1
      end
      if quiet > 480 then -- two minutes without a write: the agent is done
        timer:stop()
        timer:close()
      end
    end)
  )
end

---Reload every unmodified buffer that changed on disk, e.g. after an agent
---edited files other than the one being watched.
local function reload_changed_buffers()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and not vim.bo[b].modified and vim.bo[b].buftype == "" then
      if vim.api.nvim_buf_get_name(b) ~= "" then
        vim.api.nvim_buf_call(b, function()
          vim.cmd("silent! checktime")
        end)
      end
    end
  end
  pcall(function()
    require("gitsigns").refresh()
  end)
end

---Open a terminal buffer running cmd, in a horizontal split at the bottom.
local function terminal_split(cmd, cwd, on_exit)
  vim.cmd("botright split")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_height(0, math.max(10, math.floor(vim.o.lines * 0.35)))
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "opencode"
  vim.fn.jobstart(cmd, {
    cwd = cwd,
    term = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if code ~= 0 then
          vim.notify("opencode exited with code " .. code, vim.log.levels.WARN)
        end
        if on_exit then
          on_exit()
        end
      end)
    end,
  })
  -- q closes the agent's split once it is done; the output stays readable
  -- until you decide to dismiss it
  vim.keymap.set("n", "q", function()
    vim.cmd("close!")
  end, { buffer = buf, desc = "Close opencode" })
  vim.cmd("startinsert")
  return buf
end

---Ask opencode to change the current file (or a visual selection) in place.
---@param instruction string
---@param selection? string
function M.ask(instruction, selection)
  instruction = vim.trim(instruction or "")
  if instruction == "" then
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  local path = bufname(buf)
  if path == "" then
    vim.notify("Save the file first: opencode edits files on disk", vim.log.levels.WARN)
    return
  end
  if vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent write")
    end)
  end

  local prompt = {
    "Edit the files in this repository directly and leave the change on disk.",
    "",
    "File in focus: " .. vim.fn.fnamemodify(path, ":."),
    "Task: " .. instruction,
  }
  if selection and selection ~= "" then
    table.insert(prompt, "")
    table.insert(prompt, "Only this selection matters:")
    table.insert(prompt, "```" .. (vim.bo[buf].filetype or ""))
    table.insert(prompt, selection)
    table.insert(prompt, "```")
  end
  table.insert(prompt, "")
  table.insert(
    prompt,
    "Make the change now rather than describing it. Keep the diff small, match the existing style, and leave unrelated files alone."
  )

  watch(buf, path)
  terminal_split({ "opencode", "run", "--auto", table.concat(prompt, "\n") }, project_root(buf), reload_changed_buffers)
end

---Prompt for an instruction, then hand it to opencode.
---@param selection? string
function M.prompt(selection)
  vim.ui.input({ prompt = "opencode: " }, function(instruction)
    M.ask(instruction or "", selection)
  end)
end

---Open an interactive opencode session for the current project.
function M.tui()
  terminal_split({ "opencode" }, project_root(vim.api.nvim_get_current_buf()), reload_changed_buffers)
end

return M
