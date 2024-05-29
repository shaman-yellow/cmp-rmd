
-- lua/cmp-rmd/init.lua
local cmp = require'cmp'

local source = {}

-- Check if the source is available (only for rmd filetype)
function source:is_available()
  local filetype = vim.bo.filetype
  return filetype == 'rmd'
end

-- Custom keyword pattern to trigger completion
function source:get_keyword_pattern()
  return [[\@ref\(.*:[^)]*\)]]
end

-- Check if the cursor is within the \@ref() pattern and after the colon
local function is_in_ref_pattern()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col + 1)
  return before_cursor:match("\\@ref%([^:]+:[^)]*$") ~= nil
end

-- Gather completion items
function source:complete(params, callback)
  if not is_in_ref_pattern() then
    callback({ items = {} })
    return
  end

  local items = {}
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for _, line in ipairs(lines) do
    if vim.startswith(line, "#| ") then
      table.insert(items, { label = line:sub(4) })
    end
  end

  callback({ items = items })
end

-- Resolve completion item details (not used in this example)
function source:resolve(completion_item, callback)
  callback(completion_item)
end

-- Confirm the completion item (not used in this example)
function source:confirm(completion_item, callback)
  callback(completion_item)
end

return source
