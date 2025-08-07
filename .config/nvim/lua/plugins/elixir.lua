-- Elixir Language Server and Plugin Configuration for LazyVim
-- Add keybinding for Elixir debugging
local function setup_elixir_keys()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "elixir", "heex", "eex" },
    callback = function()
      -- Map <leader>cD to append |> dbg() to current line
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>cD",
        ":lua vim.api.nvim_set_current_line(vim.api.nvim_get_current_line() .. ' |> dbg()')<CR>",
        { noremap = true, silent = true, desc = "Append |> dbg() to current line" }
      )
    end,
  })
end

-- Call the setup function
setup_elixir_keys()

return {
  -- LSP Configuration for Elixir
  {
    "neovim/nvim-lspconfig",
  },

  -- Treesitter Configuration for Elixir and Related Languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "elixir", "heex", "eex" },
    },
  },

  -- Neotest Adapter for Elixir
  {
    "jfpedroza/neotest-elixir",
  },

  -- Neotest configuration with Elixir adapter
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-elixir"] = {
          -- Allow test_helper.exs files
          test_file_pattern = ".*%.exs$",
        },
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- Credo Integration using none-ls (configured via LazyVim extra)
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- Linting with Credo
        nls.builtins.diagnostics.credo.with({
          condition = function(utils)
            return utils.root_has_file(".credo.exs")
          end,
        }),
        -- Formatting with Mix format
        nls.builtins.formatting.mix,
      })
    end,
  },

  -- Credo Linting using nvim-lint
  --[[
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = {
        elixir = { "credo" },
      }
      opts.linters = {
        credo = {
          condition = function(ctx)
            return vim.fs.find({ ".credo.exs" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      }
    end,
  },
  -- Disabled to avoid duplicate diagnostics with none-ls
  ]]

  -- vim-test configuration
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>m", desc = "+Mix Tasks" },
      { "<leader>mt", desc = "+Tests" },
      { "<leader>mts", "<cmd>TestNearest<CR>", desc = "Run nearest test" },
      { "<leader>mtv", "<cmd>TestFile<CR>", desc = "Run test file" },
      { "<leader>mta", "<cmd>TestSuite<CR>", desc = "Run test suite" },
      { "<leader>mtr", "<cmd>TestLast<CR>", desc = "Run last test" },
      { "<leader>mtf", "<cmd>TestVisit<CR>", desc = "Visit test file" },
      {
        "<leader>mti",
        function()
          require("plugins.elixir.utils").switch_test_implementation()
        end,
        desc = "Visit implementation file",
      },
    },
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "vert"
      -- vim.g["test#elixir#exunit#options"] = "--trace"
    end,
  },
}
