return {
  -- 1) Color Scheme Plugins
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- updates parsers automatically
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "javascript",
          "lua",
          "python",
          "rust",
          "tsx",
          "typescript",
          "yaml",
        },
        highlight = { enable = true },
      }
    end
  },
  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local lackluster = require 'lackluster'
      lackluster.setup {
        tweak_color = {
          gray8 = '#7f7f7f',
          lack = '#2E3440',
        },
        tweak_syntax = {
          string = '#CD9177',
          comment = '#8f8f8f',
          keyword = '#68A891',
        },
        tweak_background = {
          normal = 'default',
        },
      }
      -- Setting one of the lackluster variants
      vim.cmd.colorscheme 'lackluster-hack'
    end,
  },

  -- 2) Rust Tools & Crates
  {
    'simrat39/rust-tools.nvim',
    -- This plugin is loaded by LSP config below, no direct config needed
  },
  {
    'saecki/crates.nvim',
    version = 'v0.3.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup {
        null_ls = {
          enabled = true,
          name = 'crates.nvim',
        },
        popup = { border = 'rounded' },
      }
    end,
  },

  -- 3) Additional UI / Utility
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup()
    end,
  },
  { 'preservim/vim-markdown' },
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    ft = { 'markdown' },
    config = function()
      -- auto-start or other config if desired
    end,
  },
  {
    'mattn/emmet-vim',
    -- optional settings:
    init = function()
      vim.g.user_emmet_leader_key = '<C-Y>'
      vim.g.user_emmet_mode = 'i'
    end,
  },

  -- 4) Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {}
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup {
        suggestion = { enabled = false },
        panel = { enabled = true },
      }
    end,
  },

  -- 5) nvim-ufo (Folding)
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      require('ufo').setup {
        provider_selector = function(_, filetype)
          -- you can adjust this logic
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },

  -- 6) DAP Support for codelldb or Python, etc.
  {
    'mfussenegger/nvim-dap', -- Typically included in many frameworks
  },
  -- If you want the Python debug adapter:
  {
    'mfussenegger/nvim-dap-python',
    dependencies = { 'nvim-dap' },
  },

  -- any other plugins...
}

-- lackluster
local lackluster = require("lackluster")

local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9

-- !must called setup() before setting the colorscheme!
lackluster.setup({
  -- You can overwrite the following syntax colors by setting them to one of...
  --   1) a hexcode like "#a1b2c3" for a custom color.
  --   2) "default" or nil will just use whatever lackluster's default is.
  tweak_color = {
    gray8 = '#7f7f7f',
    lack = '#2E3440',
  },
  tweak_syntax = {
    string = "#CD9177",
    -- string = "#a1b2c3", -- custom hexcode
    -- string = color.green, -- lackluster color
    string_escape = "default",
    comment = "#8f8f8f",
    builtin = "default", -- builtin modules and functions
    type = "default",
    keyword = "#68A891",
    keyword_return = "default",
    keyword_exception = "default",
  },
  -- You can overwrite the following background colors by setting them to one of...
  --   1) a hexcode like "#a1b2c3" for a custom color
  --   2) "none" for transparency
  --   3) "default" or nil will just use whatever lackluster's default is.
  tweak_background = {
    normal = 'default', -- main background
    -- normal = 'none',    -- transparent
    -- normal = '#a1b2c3',    -- hexcode
    -- normal = color.green,    -- lackluster color
    telescope = 'default', -- telescope
    menu = 'default',      -- nvim_cmp, wildmenu ... (bad idea to transparent)
    popup = 'default',     -- lazy, mason, whichkey ... (bad idea to transparent)
  },

})
