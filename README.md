<h1 align="center">
  <img src="https://i.postimg.cc/0QL5cs9T/carbonvim.jpg" />
</h1>

<div align="center">
  <p><strong>Create beautiful code snippets directly from your neovim terminal</strong></p>
  <img src="https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua" />
  <img src="https://img.shields.io/github/actions/workflow/status/ellisonleao/carbon-now.nvim/lint-test.yml?style=for-the-badge" />
</div>

## Requirements

Neovim 0.8+

## Installing

Using your preferred plugin manager, add:

```
'ellisonleao/carbon-now.nvim'
```

Example with packer:

```lua
use {"ellisonleao/carbon-now.nvim", config = function() require('carbon-now').setup() end}
```

Example with lazy.nvim:

```lua
{
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  ---@param opts cn.ConfigSchema
  opts = { [[ your custom config here ]] }
}
```

## Configuration and customization

The plugin comes with the following default configs:

```lua
{
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
    theme = "monokai",
    titlebar = "Made with carbon-now.nvim",
    watermark = false,
    width = "680",
    window_theme = "sharp",
  },
}
```

You can override it in `setup()` function. Example:

```lua
local carbon = require('carbon-now')
carbon.setup({
  options = {
    theme = "solarized",
    font_family = "Monoid",
  }
})
```

## Generating snippets from visual selection

Adding a custom mapping for generating a new snippet is really easy

```lua
vim.keymap.set("v", "<leader>cn", ":CarbonNow<CR>", { silent = true })
```

But if you preferer a command, visual select the code you want to share and call:

```
:CarbonNow
```

## Generating snippets from github gists

```
:CarbonNow GIST_ID
```

## Changing default open in browser command

Example: Opening snippet in google-chrome

```lua
require('carbon-now').setup({open_cmd = "google-chrome"})
```