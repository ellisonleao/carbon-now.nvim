local cn = {}

---@alias cn.WindowThemes 'none' | 'sharp' | 'bw' | 'boxy'
cn.WindowThemes = {
  none = "none",
  sharp = "sharp",
  bw = "bw",
  boxy = "boxy",
}

---@alias cn.Themes '3024-night' | 'a11y-dark' | 'blackboard' | 'base-16-dark' | 'base-16-light' | 'cobalt' | 'dracula-pro' | 'duotone' | 'hopscotch' | 'lucario' | 'material' | 'monokai' | 'night-owl' | 'nord' | 'oceanic-next' | 'one-light' | 'one-dark' | 'panda' | 'paraiso' | 'seti' | 'shades-of-purple' | 'solarized-dark' | 'solarized-light' | 'synthwave-84' | 'twilight' | 'terminal' | 'vscode' | 'yeti' | 'zenburn'
cn.Themes = {
  ["3024-night"] = "3024-night",
  ["a11y-dark"] = "a11y-dark",
  blackboard = "blackboard",
  ["base-16-dark"] = "base-16-dark",
  ["base-16-light"] = "base-16-light",
  cobalt = "cobalt",
  ["dracula-pro"] = "dracula-pro",
  duotone = "duotone",
  hopscotch = "hopscotch",
  lucario = "lucario",
  material = "material",
  monokai = "monokai",
  ["night-owl"] = "night-owl",
  nord = "nord",
  ["oceanic-next"] = "oceanic-next",
  ["one-light"] = "one-light",
  ["one-dark"] = "one-dark",
  panda = "panda",
  paraiso = "paraiso",
  seti = "seti",
  ["shades-of-purple"] = "shades-of-purple",
  ["solarized-dark"] = "solarized-dark",
  ["solarized-light"] = "solarized-light",
  ["synthwave-84"] = "synthwave-84",
  twilight = "twilight",
  terminal = "terminal",
  vscode = "vscode",
  yeti = "yeti",
  zenburn = "zenburn",
}
---@class cn.ConfigSchema
---@field public base_url string
---@field public open_cmd string
---@field public options cn.WindowOptions

---@class cn.WindowOptions
---@field public bg string
---@field public drop_shadow_blur string
---@field public drop_shadow_offset_y string
---@field public font_family string
---@field public font_size string
---@field public line_height string
---@field public drop_shadow boolean
---@field public line_number boolean
---@field public theme cn.Themes
---@field public titlebar string
---@field public watermark boolean
---@field public width string
---@field public window_theme cn.WindowThemes

return cn
