return {
  {
    'OXY2DEV/markview.nvim',
    dependencies = { 'slugbyte/lackluster.nvim' },
    lazy = false,
    config = function()
      local presets = require 'markview.presets'
      vim.g.markview_dark_bg = '#1a1a1a'

      require('markview').setup {
        -- Your existing configuration...
        markdown = {
          -- 2. ADD THIS: Explicitly force the code block style to be readable
          code_blocks = {

            enable = true,
            style = 'fenced', -- Options: "fenced", "simple"
            hl = 'MarkviewCode', -- Highlight group for the block

            -- Language tag settings
            info_hl = 'MarkviewCodeInfo',
            pad_amount = 3,
          },
          headings = presets.headings.slanted,

          -- Set tables to have no lines/borders
          tables = presets.tables.rounded,
        },
        latex = {
          enable = true,
          inlines = { enable = true, hl = 'MarkviewInlineCode' },
          blocks = { enable = true, hl = 'MarkviewCode' },
          -- ... rest of your latex config
        },
      }

      -- 3. MANUAL OVERRIDE (The "Nuclear" Option)
      -- If the text is still unreadable, run these to force Lackluster-friendly colors
      vim.api.nvim_set_hl(0, 'MarkviewCode', { bg = '#111111' })
      vim.api.nvim_set_hl(0, 'MarkviewInlineCode', { bg = '#111111' })
    end,
  },
}
