local M = {}

function M.load_env(file)
  for line in io.lines(file) do
    local key, val = line:match '^(%S+)%s*=%s*(.+)$'
    if key and val then
      vim.fn.setenv(key, val)
    end
  end
end

return M
