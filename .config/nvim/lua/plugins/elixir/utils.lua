local M = {}

-- Function to switch between test and implementation files
function M.switch_test_implementation()
  local current_file = vim.fn.expand("%:p")
  local target_file

  if current_file:match("_test%.exs$") then
    -- We're in a test file, switch to implementation
    target_file = current_file:gsub("/test/", "/lib/"):gsub("_test%.exs$", ".ex")
  elseif current_file:match("%.ex$") then
    -- We're in an implementation file, switch to test
    target_file = current_file:gsub("/lib/", "/test/"):gsub("%.ex$", "_test.exs")
  else
    vim.notify("Not a recognized Elixir file type", vim.log.levels.WARN)
    return
  end

  if vim.fn.filereadable(target_file) == 1 then
    local ok, err = pcall(vim.cmd, "edit " .. target_file)
    if not ok then
      vim.notify("Failed to open file: " .. target_file .. (err and (" (" .. err .. ")") or ""), vim.log.levels.ERROR)
      return
    end
  else
    -- Create directory if it doesn't exist
    local target_dir = vim.fn.fnamemodify(target_file, ":h")
    if vim.fn.isdirectory(target_dir) == 0 then
      local ok = vim.fn.mkdir(target_dir, "p")
      if ok == 0 then
        vim.notify("Failed to create directory: " .. target_dir, vim.log.levels.ERROR)
        return
      end
    end

    -- Create and open the new file
    local ok, err = pcall(vim.cmd, "edit " .. target_file)
    if not ok then
      vim.notify("Failed to open file: " .. target_file .. (err and (" (" .. err .. ")") or ""), vim.log.levels.ERROR)
      return
    end

    if current_file:match("%.ex$") then
      -- Extract full module path from the implementation file path
      local rel_path = current_file:match(".*/lib/(.+)%.ex$")
      if rel_path then
        -- Convert path to module name
        local module_name = rel_path
          :gsub("/", ".")
          :gsub("_(%l)", function(l)
            return l:upper()
          end) -- convert snake_case to camelCase
          :gsub("^%l", string.upper) -- capitalize first letter
          :gsub("%.%l", string.upper) -- capitalize letters after dots

        -- Generate test module content
        local test_content = string.format(
          [[
defmodule %sTest do
  use ExUnit.Case
  doctest %s

  test "greets the world" do
    assert true
  end
end]],
          module_name,
          module_name
        )

        -- Insert the test module content
        local ok_buf = pcall(vim.api.nvim_buf_set_lines, 0, 0, -1, false, vim.split(test_content, "\n"))
        if not ok_buf then
          vim.notify("Failed to set buffer lines for: " .. target_file, vim.log.levels.ERROR)
          return
        end

        -- Save the file
        local ok_write, err_write = pcall(vim.cmd, "write")
        if not ok_write then
          vim.notify(
            "Failed to write file: " .. target_file .. (err_write and (" (" .. err_write .. ")") or ""),
            vim.log.levels.ERROR
          )
          return
        end
      end
    end
  end
end

return M
