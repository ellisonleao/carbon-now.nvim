-- module represents a lua module for the plugin
local M = {}
local is_loaded = false

-- default configs
local defaults = {
  base_url = "https://carbon.now.sh/",
  open_cmd = "xdg-open",
  options = {
    theme = "monokai",
    window_theme = "none",
    font_family = "Hack",
    font_size = "18px",
    bg = "gray",
    line_numbers = true,
    line_height = "133%",
    drop_shadow = false,
    drop_shadow_offset_y = "20px",
    drop_shadow_blur = "68px",
    width = "680",
    watermark = false,
  },
}

M.config = {}

-- generates an query encoded string
--@param str string
local function query_param_encode(str)
  str = string.gsub(str, "\r?\n", "\r\n")
  str = string.gsub(str, "([^%w%-%.%_%~ ])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)

  str = string.gsub(str, " ", "+")
  return str
end

-- helper function to encode a k,v table into encoded query params
--@param values table
local function encode_params(values)
  local params = {}
  for k, v in pairs(values) do
    if type(v) ~= "string" then
      v = tostring(v)
    end
    table.insert(params, k .. "=" .. query_param_encode(v))
  end

  local output = table.concat(params, "&")
  return output
end

-- validate config param values and create the query params table
--@param code string
local function generate_query_params(code)
  local opts = M.config.options
  local params = {
    t = opts.theme,
    wt = opts.window_theme,
    fm = opts.font_family,
    fs = opts.font_size,
    bg = opts.bg,
    ln = opts.line_number,
    lh = opts.line_height,
    ds = opts.drop_shadow,
    dsyoff = opts.drop_shadow_offset_y,
    dsblur = opts.drop_shadow_blur,
    wm = opts.watermark,
  }

  if code ~= nil then
    params.code = code
    params.l = vim.bo.filetype
  end

  return encode_params(params)
end

-- grabs the visual selection lines and returns a table where each line represents a table item
--@return table
local function grab_selected_lines()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line, end_line = start_pos[2], end_pos[2]
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  return lines
end

--@return string
local function get_open_command()
  if vim.fn.executable(M.config.open_cmd) then
    return M.config.open_cmd
  end

  -- fallbacks
  if vim.fn.executable("open") then
    return "open"
  end

  -- windows fallback
  if vim.fn.has("win32") then
    return "start"
  end
end

local function create_commands()
  vim.cmd([[
command! -range=% CarbonNow <line1>,<line2>:lua require('carbon-now').create_snippet()
command! -nargs=1 CarbonNowGist :lua require('carbon-now').create_snippet_from_gist(<f-args>)
]])
end

-- setup is the initialization function for the carbon plugin
--@param params table
M.setup = function(params)
  M.config = vim.tbl_deep_extend("force", {}, defaults, params or {})
  create_commands()
  is_loaded = true
end

M.create_snippet = function()
  if not is_loaded then
    vim.api.nvim_err_writeln("setup() method must be called in order to create snippets")
    return
  end

  local lines = grab_selected_lines()
  if #lines == 0 then
    return
  end

  lines = table.concat(lines, "\n", 1, #lines)

  local open_cmd = get_open_command()
  local query_params = generate_query_params(lines)
  local url = M.config.base_url .. "?" .. query_params
  local cmd = open_cmd .. " " .. "'" .. url .. "'"

  vim.fn.system(cmd)
end

--@param gist_id string
M.create_snippet_from_gist = function(gist_id)
  local open_cmd = get_open_command()
  local query_params = generate_query_params()
  local url = M.config.base_url .. "/" .. gist_id .. "?" .. query_params
  local cmd = open_cmd .. " " .. "'" .. url .. "'"

  vim.fn.system(cmd)
end

return M
