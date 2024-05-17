-- module represents a lua module for the plugin
---@module 'carbon-now'
---@class Carbon
---@field config ConfigSchema
---@field setup SetupFunc
local Carbon = {}

--- Types
---@alias Themes '3024-night' | 'a11y-dark' | 'blackboard' | 'base-16-dark' | 'base-16-light' | 'cobalt' | 'dracula-pro' | 'duotone' | 'hopscotch' | 'lucario' | 'material' | 'monokai' | 'night-owl' | 'nord' | 'oceanic-next' | 'one-light' | 'one-dark' | 'panda' | 'paraiso' | 'seti' | 'shades-of-purple' | 'solarized-dark' | 'solarized-light' | 'synthwave-84' | 'twilight' | 'terminal' | 'vscode' | 'yeti' | 'zenburn'

---@class WindowOptions
---@field public bg string
---@field public drop_shadow_blur string
---@field public drop_shadow_offset_y string
---@field public font_family string
---@field public font_size string
---@field public line_height string
---@field public line_numbers boolean
---@field public drop_shadow boolean
---@field public theme Themes
---@field public titlebar string
---@field public watermark boolean
---@field public width string
---@field public window_theme 'none' | 'sharp' | 'bw' | 'boxy'
---@field public padding_vertical string
---@field public padding_horizontal string

---@class ConfigSchema
---@field public base_url string
---@field public options WindowOptions

---@alias SetupFunc fun(params: ConfigSchema)

-- map some known filetypes to carbon.now.sh supported languages
--- list of supported languages: https://github.com/carbon-app/carbon/blob/2cbdcd0cc23d2d2f23736dd3cfbe94134b141191/lib/constants.js#L624-L1048
--- TODO: check possible removal of this in favor of vim.filetype
local language_map = {
  typescriptreact = "typescript",
  javascriptreact = "javascript",
}

-- default config
Carbon.config = {
  base_url = "https://carbon.now.sh/",
  options = {
    bg = "gray",
    drop_shadow_blur = "68px",
    drop_shadow = false,
    drop_shadow_offset_y = "20px",
    font_family = "Hack",
    font_size = "18px",
    line_height = "133%",
    line_numbers = true,
    theme = "monokai",
    titlebar = "Made with carbon-now.nvim",
    watermark = false,
    width = "680",
    window_theme = "sharp",
    padding_horizontal = "0px",
    padding_vertical = "0px",
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
---as query parameters. Ex: {a = b, c = d} --> a=b&c=d
---@param values table
---@return string # Concatenation of the encoded query parameters
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
  local opts = Carbon.config.options
  local ft = vim.bo.filetype

  -- carbon.now.sh parameters
  local params = {
    t = opts.theme,
    l = language_map[ft] or ft,
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
    pv = opts.padding_vertical,
    ph = opts.padding_horizontal,
  }

  return encode_params(params)
end

---@param opts {args: string, line1: integer, line2: integer}
local function create_snapshot(opts)
  ---@type string, string
  local url, query_params

  -- create Uri
  if opts.args ~= "" then
    query_params = get_carbon_now_snapshot_uri()
    url = Carbon.config.base_url .. "/" .. opts.args .. "?" .. query_params
  else
    local range = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
    local code = table.concat(range, "\n", 1, #range)
    query_params = get_carbon_now_snapshot_uri(code)
    url = Carbon.config.base_url .. "?" .. query_params
  end

  -- launch the Uri
  vim.ui.open(url)
end

local function create_commands()
  vim.api.nvim_create_user_command("CarbonNow", function(opts)
    create_snapshot(opts)
  end, { range = "%", nargs = "?" })
end

--- initialization function for the carbon plugin commands
Carbon.setup = function(params)
  Carbon.config = vim.tbl_deep_extend("force", {}, Carbon.config, params or {})
  create_commands()
end

return Carbon
