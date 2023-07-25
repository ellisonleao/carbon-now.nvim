-- module represents a lua module for the plugin
local types = require("types")
local carbon = {}

-- default config
---@type cn.ConfigSchema
carbon.config = {
  base_url = "https://carbon.now.sh/",
  open_cmd = "xdg-open",
  options = {
    bg = "gray",
    drop_shadow_blur = "68px",
    drop_shadow = false,
    drop_shadow_offset_y = "20px",
    font_family = "Hack",
    font_size = "18px",
    line_height = "133%",
    line_numbers = true,
    theme = types.Themes.monokai,
    titlebar = "Made with carbon-now.nvim",
    watermark = false,
    width = "680",
    window_theme = types.WindowThemes.sharp,
  },
}

---encodes a given [str] string
---@param str string
---@return string str 'Encoded string'
---@nodiscard
local function query_param_encode(str)
  str = string.gsub(str, "\r?\n", "\r\n")
  str = string.gsub(str, "([^%w%-%.%_%~ ])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)

  str = string.gsub(str, " ", "+")
  return str
end

---helper function to encode and concatenate a [k,v] table
---as query parameters. iEx: {a = b, c = d} --> a=b&c=d
---@param values table
---@return string # Concatanation of the enconded query parameters
---@nodiscard
local function encode_params(values)
  ---@type table<string, any>
  local params = {}
  for k, v in pairs(values) do
    if type(v) ~= "string" then
      v = tostring(v)
    end
    table.insert(params, k .. "=" .. query_param_encode(v))
  end

  return table.concat(params, "&")
end

---@param code string?
---@return string # global parameters for the endpoint
---@nodiscard
---validate config param values and create the query params table
local function get_carbon_now_snapshot_uri(code)
  local opts = carbon.config.options

  -- carbon.now.sh parameters
  local params = {
    t = opts.theme,
    l = vim.bo.filetype,
    wt = opts.window_theme,
    fm = opts.font_family,
    fs = opts.font_size,
    bg = opts.bg,
    ln = opts.line_numbers,
    lh = opts.line_height,
    ds = opts.drop_shadow,
    dsyoff = opts.drop_shadow_offset_y,
    dsblur = opts.drop_shadow_blur,
    wm = opts.watermark,
    tb = opts.titlebar,
    code = code,
  }

  return encode_params(params)
end

---@nodiscard
---@return string
--- Returns the launch command. If no launch command is
--- available an exception will be raised.
local function get_open_command()
  -- default launcher
  if vim.fn.executable(carbon.config.open_cmd) then
    return carbon.config.open_cmd
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

---@param opts {args: string, line1: integer, line2: integer}
local function create_snapshot(opts)
  -- get launch command
  local open_cmd = get_open_command()

  ---@type string, string
  local url, query_params

  -- create Uri
  if opts.args ~= "" then
    query_params = get_carbon_now_snapshot_uri()
    url = carbon.config.base_url .. "/" .. opts.args .. "?" .. query_params
  else
    local range = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
    local code = table.concat(range, "\n", 1, #range)
    query_params = get_carbon_now_snapshot_uri(code)
    url = carbon.config.base_url .. "?" .. query_params
  end

  -- launch the Uri
  local cmd = open_cmd .. " " .. "'" .. url .. "'"
  vim.fn.system(cmd)
end

local function create_commands()
  ---@param opts table<string, any>
  vim.api.nvim_create_user_command("CarbonNow", function(opts)
    create_snapshot(opts)
  end, { range = "%", nargs = "?" })
end

--- initialization function for the carbon plugin commands
---@param params cn.ConfigSchema?
carbon.setup = function(params)
  carbon.config = vim.tbl_deep_extend("force", {}, carbon.config, params or {})
  create_commands()
end

return carbon