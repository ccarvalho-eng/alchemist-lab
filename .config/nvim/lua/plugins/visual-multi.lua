return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  config = function()
    -- Fix terminal key codes for Ctrl-Arrow keys
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Add Cursor Down"] = "<C-j>", -- Use Ctrl-j instead
      ["Add Cursor Up"] = "<C-k>", -- Use Ctrl-k instead
      ["Select All"] = "\\A",
      ["Start Regex Search"] = "\\/",
      ["Add Cursor At Pos"] = "\\\\",
    }
  end,
}
