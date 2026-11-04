-- Terminal: leave terminal mode
vim.api.nvim_set_keymap('t', '<A-Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Toggleterm
map('n', '<A-1>', '<Cmd>ToggleTerm direction=horizontal<CR>', opts)
map('t', '<A-1>', '<Cmd>ToggleTerm direction=horizontal<CR>', opts)
map('n', '<A-2>', '<Cmd>ToggleTerm direction=float<CR>', opts)
map('t', '<A-2>', '<Cmd>ToggleTerm direction=float<CR>', opts)
map('n', '<Space>e', '<Cmd>Neotree toggle<CR>', opts)

-- Move line up and down with Alt+j and Alt+k in normal mode
vim.api.nvim_set_keymap('n', '<M-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-k>', ':m .-2<CR>==', { noremap = true, silent = true })

-- Move selected lines up and down with Alt+j and Alt+k in visual mode
vim.api.nvim_set_keymap('v', '<M-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<M-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Resizing
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { noremap = true, silent = true })

-- Git
map('n', '<Space>hh', ':0Gclog<CR>', opts)
map('n', '<Space>mb', ':diffget \\1<CR>', opts)
map('n', '<Space>ms', ':diffget \\2<CR>', opts)
map('n', '<Space>mt', ':diffget \\3<CR>', opts)

map('n', '<Space>hm', '<Cmd>DiffviewOpen<CR>', opts)

-- New tab
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })

-- Close tab
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close tab' })
