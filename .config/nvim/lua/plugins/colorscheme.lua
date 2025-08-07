return {
  -- Add the onedark theme
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- Make sure it loads first
    event = "VeryLazy",
    config = function()
      require("onedark").setup({
        -- Customize the theme here (optional)
        style = "dark", -- Options: dark, darker, cool, deep, warm, warmer
      })
    end,
  },

  -- Set it as the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
