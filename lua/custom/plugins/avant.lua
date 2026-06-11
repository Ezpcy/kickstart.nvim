return {
  'yetone/avante.nvim',
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = 'avante.md',
    -- for example
    auto_suggestions_provider = 'copilot', -- copilot for inline suggestions
    provider = 'claude-code',
    providers = {
      copilot = {
        model = 'claude-haiku-4.5',
      },
    },
    acp_providers = {
      ['opencode'] = {
        command = 'opencode',
        args = { 'acp' },
        model = 'antigravity-claude-sonnet-4-6',
        env = {
          NODE_NO_WARNINGS = '1',
          HOME = os.getenv 'HOME',
        },
      },
      ['claude-code'] = {
        command = 'claude-agent-acp',
        args = {},
        env = {
          NODE_NO_WARNINGS = '1',
          ANTHROPIC_API_KEY = os.getenv 'ANTHROPIC_API_KEY',
        },
      },
    },
    input = {
      provider = 'dressing',
    },
    selection = {
      hint_display = 'none',
    },
    mappings = {},
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-mini/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'stevearc/dressing.nvim', -- for input provider dressing
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
  },
}
