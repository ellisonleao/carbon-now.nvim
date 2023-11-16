---@nodiscard
---@return string
--- Returns the launch command. If no launch command is
--- available an exception will be raised.
local function get_open_command(open_cmd)
  -- default launcher
  open_cmd = open_cmd or "xdg-open"
  if vim.fn.executable(open_cmd) then
    return open_cmd
  end

  -- alternative launcher
  if vim.fn.executable("open") then
    return "open"
  end

  -- windows fallback
  if vim.fn.has("win32") then
    return "start"
  end

  vim.api.nvim_err_writeln("[carbon-now.nvim] Couldn't find a launch command")
  return "echo"
end

local function open(url, open_cmd)
  -- also use the system command if open_cmd is set
  if vim.ui.open == nil or open_cmd ~= nil then
    vim.fn.system({ get_open_command(open_cmd), "'" .. str .. "'" })
  else
    vim.ui.open(url)
  end
end

return open