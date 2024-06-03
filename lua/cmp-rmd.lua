
local cmp = require'cmp'
local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

function source:is_available()
  return vim.bo.filetype == 'rmd'
end

function source:get_debug_name()
  return 'rmd'
end

local function read_lines_from_files(dir)
  local items = {}
  local scan = require'plenary.scandir'
  local files = scan.scan_dir(dir, { hidden = true, depth = 1 })

  for _, file in ipairs(files) do
    for line in io.lines(file) do
      table.insert(items, { label = line })
    end
  end

  return items
end

function source:complete(params, callback)
  -- local dir_path = vim.fn.expand('~/.config/nvim/SelectCompletion')
  local dir_path = vim.g.SelectCompletion or ''
  local items = {}
  if vim.fn.isdirectory(dir_path) == 1 then
    items = read_lines_from_files(dir_path)
  end
  callback({ items = items, isIncomplete = false })
end

return source
