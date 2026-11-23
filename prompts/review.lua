local MAX = 60000

---@param ctx table buffer context from CodeCompanion
---@param extra string[] git diff args
local function git_diff(ctx, extra)
  local root = vim.fs.root(ctx.path or vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()
  local cmd = { "git", "-C", root, "diff", "--no-ext-diff" }
  vim.list_extend(cmd, extra)

  local ok, res = pcall(function()
    return vim.system(cmd, { text = true }):wait()
  end)
  local out = ok and res and res.stdout or ""
  if out == nil or out == "" then
    return "(none)"
  end
  if #out > MAX then
    return out:sub(1, MAX) .. "\n... (truncated)"
  end
  return out
end

return {
  staged = function(ctx)
    return git_diff(ctx, { "--staged" })
  end,
  unstaged = function(ctx)
    return git_diff(ctx, {})
  end,
}
