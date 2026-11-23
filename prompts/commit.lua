return {
  diff = function()
    local ok, res = pcall(function()
      return vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()
    end)
    local out = ok and res and res.stdout or ""
    if out == nil or out == "" then
      return "(nothing staged)"
    end
    if #out > 40000 then
      return out:sub(1, 40000) .. "\n... (truncated)"
    end
    return out
  end,
}
