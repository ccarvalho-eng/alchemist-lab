-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Open terminal in a horizontal split with a specified height
vim.api.nvim_set_keymap(
  "n",
  "<leader>th",
  ":split | resize 20 | terminal<CR>",
  { noremap = true, silent = true, desc = "Open terminal (horizontal split)" }
)

-- Open terminal in a vertical split with a specified width
vim.api.nvim_set_keymap(
  "n",
  "<leader>tv",
  ":vsplit | vertical resize 80 | terminal<CR>",
  { noremap = true, silent = true, desc = "Open terminal (vertical split)" }
)

-- Keybinding to delete all buffers
vim.keymap.set("n", "<leader>bK", ":%bd<CR>", { noremap = true, silent = true, desc = "Close all buffers" })

-- Kwymap for getting the current file path
vim.keymap.set("n", "<leader>fl", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy current file path to clipboard" })
