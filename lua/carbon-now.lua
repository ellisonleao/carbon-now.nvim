-- module represents a lua module for the plugin
local carbon = {}

-- default configs
carbon.config = {
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

-- generates an query encoded string
local function query_param_encode(str)
  str = string.gsub(str, "\r?\n", "\r\n")
  str = string.gsub(str, "([^%w%-%.%_%~ ])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)

  str = string.gsub(str, " ", "+")
  return str
end

-- helper function to encode a k,v table into encoded query params
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
local function generate_query_params(code)
  local opts = carbon.config.options
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

local function get_open_command()
  if vim.fn.executable(carbon.config.open_cmd) then
    return carbon.config.open_cmd
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

local function create_snippet(opts)
  local open_cmd = get_open_command()
  local url
  local query_params

  if opts.args ~= "" then
    query_params = generate_query_params()
    url = carbon.config.base_url .. "/" .. opts.args .. "?" .. query_params
  else
    local range = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
    local lines = table.concat(range, "\n", 1, #range)
    query_params = generate_query_params(lines)
    url = carbon.config.base_url .. "?" .. query_params
  end

  local cmd = open_cmd .. " " .. "'" .. url .. "'"
  vim.fn.system(cmd)
end

local function create_commands()
  vim.api.nvim_create_user_command("CarbonNow", function(opts)
    create_snippet(opts)
  end, { range = "%", nargs = "?" })
end

-- setup is the initialization function for the carbon plugin
carbon.setup = function(params)
  carbon.config = vim.tbl_deep_extend("force", {}, carbon.config, params or {})
  create_commands()
end

return carbon
