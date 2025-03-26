-- Some user options
vim.opt.linebreak = true
-- vim.opt.spell = true
vim.opt.spelllang = 'en,de'
vim.opt.spellfile = '~/.config/nvim/spell/de.utf-8.add'
-- Transparent
vim.g.transparent_window = true
-- Format on save (if you want with null-ls, etc.)
-- You can also set up an autocmd for that

-- Keymaps

-- Example function that replaces whitespace with linebreak
function _G.replace_whitespace_with_linebreak()
  vim.cmd [['<,'>s/\s\+/\r/g]]
end

vim.keymap.set('v', '<Leader>r', ':lua replace_whitespace_with_linebreak()<CR>')

-- Enable spell checking for Markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en,de'
    vim.opt_local.spellfile = '~/.config/lvim/spell/de.utf-8.add'
  end,
})

vim.colorscheme = 'lackluster-hack'
vim.format_on_save = false
vim.cmd [[
  autocmd FileType markdown setlocal wrap
  autocmd FileType markdown setlocal linebreak
]]
