return {
  -- Plugin: folke/todo-comments.nvim
  -- URL: https://github.com/folke/todo-comments.nvim
  -- Description: Plugin to highlight and search for TODO, FIX, HACK, etc. comments in your code.
  -- IMPORTANT: using version "*" to fix a bug
  { "folke/todo-comments.nvim", version = "*" },

  -- Plugin: folke/which-key.nvim
  -- URL: https://github.com/folke/which-key.nvim
  -- Description: Plugin to show a popup with available keybindings.
  -- IMPORTANT: using event "VeryLazy" to optimize loading time
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "classic",
      win = { border = "single" },
    },
  },

  -- Plugin: nvim-docs-view
  -- URL: https://github.com/amrbashir/nvim-docs-view
  -- Description: A Neovim plugin for viewing documentation.
  -- {
  --   "amrbashir/nvim-docs-view",
  --   lazy = true, -- Load this plugin lazily
  --   cmd = "DocsViewToggle", -- Command to toggle the documentation view
  --   opts = {
  --     position = "right", -- Position the documentation view on the right
  --     width = 60, -- Set the width of the documentation view
  --   },
  -- },

  {
    "nvim-lualine/lualine.nvim",
  },

  -- Plugin: incline.nvim
  -- URL: https://github.com/b0o/incline.nvim
  -- Description: A Neovim plugin for showing the current filename in a floating window.
  {
    "b0o/incline.nvim",
    event = "BufReadPre", -- Load this plugin before reading a buffer
    priority = 1200, -- Set the priority for loading this plugin
    config = function()
      require("incline").setup({
        window = { margin = { vertical = 0, horizontal = 1 } }, -- Set the window margin
        hide = {
          cursorline = true, -- Hide the incline window when the cursorline is active
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t") -- Get the filename
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename -- Indicate if the file is modified
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename) -- Get the icon and color for the file
          return { { icon, guifg = color }, { " " }, { filename } } -- Return the rendered content
        end,
      })
    end,
  },

  -- Plugin: folke/snacks.nvim
  -- URL: https://github.com/folke/snacks.nvim
  -- Description: Collection of small QoL plugins for Neovim
  -- Configured for elegant UI with minimal visual noise
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
  █████╗ ██╗     ███████╗██╗  ██╗
 ██╔══██╗██║     ██╔════╝╚██╗██╔╝
 ███████║██║     █████╗   ╚███╔╝ 
 ██╔══██║██║     ██╔══╝   ██╔██╗ 
 ██║  ██║███████╗███████╗██╔╝ ██╗
 ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝
]],
        },
      },
    },
  },
}
