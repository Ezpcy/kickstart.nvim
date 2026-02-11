return {
  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local lackluster = require 'lackluster'

      lackluster.setup {
        tweak_color = {
          gray8 = '#7f7f7f',
          -- lack = '#2c2c2c',
        },
        tweak_syntax = {
          string = '#CD9177',
          comment = '#8f8f8f',
          keyword = '#68A891',
        },
        tweak_background = {
          normal = 'none',
        },
      }
      -- Setting one of the lackluster variants
      vim.cmd.colorscheme 'lackluster-hack'
    end,
  },
}
