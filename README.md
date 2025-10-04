# Fatebook.nvim

A Neovim plugin for creating predictions on [Fatebook](https://fatebook.io).

## Features

- Create predictions directly from Neovim with a simple command
- Automatic date format conversion (DD-MM-YYYY)
- Percentage-based forecasts (0-100)
- Success/error notifications

## Installation

### LazyVim / lazy.nvim

Add this to your LazyVim config (e.g., `~/.config/nvim/lua/plugins/fatebook.lua`):

```lua
return {
  "f0ldspace/fatebook.nvim",
  config = function()
    require("fatebook").setup({
      api_key = "your-api-key-here"
    })
  end,
}
```


## Usage

Use the `:Predict` command to create predictions:

```vim
:Predict "Will this work?", 55, 04-10-2025
```

### Format

```vim
:Predict "question", forecast, DD-MM-YYYY
```

- **Question**: Text in quotes (or without quotes if no commas in the question)
- **Forecast**: Number between 0-100 (percentage probability)
- **Date**: DD-MM-YYYY format (e.g., 31-12-2025)

