return {
  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local lackluster = require 'lackluster'

      lackluster.setup {
        tweak_color = {
          -- lack = '#2c2c2c',
          gray8 = '#b3b3b3',
        },
        tweak_syntax = {
          string = '#CD9177',
          comment = '#8f8f8f',
          keyword = '#68A891',
        },
        tweak_background = {
          normal = 'none',
          telescope = '#080808',
          menu = '#080808',
          popup = '#080808',
        },
      }
      -- Setting one of the lackluster variants
      vim.cmd.colorscheme 'lackluster-hack'
    end,
  },
}
