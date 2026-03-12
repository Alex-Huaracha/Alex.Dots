return {
  -- =============================================================================
  -- Catppuccin (disabled - previous configuration)
  -- =============================================================================
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   opts = {
  --     flavour = "mocha", -- latte, frappe, macchiato, mocha
  --     transparent_background = false, -- disables setting the background color.
  --     term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
  --   },
  -- },

  -- =============================================================================
  -- OneDark - Visual style inspired by Avante.nvim
  -- URL: https://github.com/navarasu/onedark.nvim
  -- Elegant and minimalist color palette without harsh colors
  -- =============================================================================
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      -- Theme style: dark, darker, cool, deep, warm, warmer
      style = "dark",

      -- Transparent background (false to keep elegant dark background)
      transparent = false,

      -- Terminal colors
      term_colors = false,

      -- Don't show ~ at end of buffer
      ending_tildes = false,

      -- Code style
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      -- Lualine
      lualine = {
        transparent = false,
      },

      -- Custom highlights for diagnostic visibility (Avante-style colors)
      highlights = {
        DiagnosticVirtualTextError = { fg = "#e06c75" },
        DiagnosticVirtualTextWarn = { fg = "#e5c07b" },
        DiagnosticVirtualTextInfo = { fg = "#56b6c2" },
        DiagnosticVirtualTextHint = { fg = "#98c379" },
      },
    },
  },

  -- Configure LazyVim to use OneDark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
