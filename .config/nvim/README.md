# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).  
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

---

## Custom Features & Plugins

### Elixir Development

- **LSP, Treesitter, and Neotest** for Elixir, HEEx, and EEx.
- **Credo linting** via both `none-ls` and `nvim-lint` (ensure only one is active to avoid duplicate diagnostics).
- **Test/Implementation Switcher**: Quickly jump between test and implementation files. If the test file doesn't exist, it will be scaffolded.
- **Debug Keymap**: `<leader>cD` appends `|> dbg()` to the current line in Elixir files.
- **Test Runner**: Keymaps for running nearest test, file, suite, last, and visiting test files.

### CSV Tools

- Enhanced CSV navigation and text objects.
- Excel-like navigation with `<Tab>`, `<S-Tab>`, `<Enter>`, `<S-Enter>`.

---

## Keymaps

| Keymap        | Mode | Description                             |
| ------------- | ---- | --------------------------------------- |
| `<leader>cD`  | n    | Append `|> dbg()` (Elixir)              |
| `<leader>mti` | n    | Switch test/implementation (Elixir)     |
| `<leader>mts` | n    | Run nearest test (Elixir)               |
| `<leader>mtv` | n    | Run test file (Elixir)                  |
| `<leader>mta` | n    | Run test suite (Elixir)                 |
| `<leader>mtr` | n    | Run last test (Elixir)                  |
| `<leader>mtf` | n    | Visit test file (Elixir)                |
| `<leader>th`  | n    | Open terminal (horizontal split)        |
| `<leader>tv`  | n    | Open terminal (vertical split)          |
| `<leader>bK`  | n    | Close all buffers                       |
| `<leader>fl`  | n    | Copy current file path to clipboard     |

---

## Usage Notes

- **Elixir Test/Implementation Switcher**: Use `<leader>mti` in an Elixir file to jump between test and implementation. If the target file doesn't exist, it will be created with a template.
- **Feed Reader**: Use `<leader>rf` to open, `<leader>ru` to update feeds.
- **Copilot Chat**: Use `<leader>aa` to toggle, `<leader>aq` for quick questions.
- **CSV Navigation**: Use `<Tab>`, `<S-Tab>`, `<Enter>`, `<S-Enter>` in CSV files for fast navigation.

---

For more details, see the plugin files in `lua/plugins/` and config files in `lua/config/`.
