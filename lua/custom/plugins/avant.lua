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
    instructions_file = 'CLAUDE.md',
    -- for example
    -- auto_suggestions_provider = 'local',
    provider = 'claude-code',
    providers = {
      copilot = {},
      -- ['local'] = {
      --   __inherited_from = 'openai',
      --   endpoint = 'http://127.0.0.1:5023/v1',
      --   api_key_name = 'mango',
      -- },
    },
    acp_providers = {
      ['opencode'] = {
        command = 'opencode',
        args = { 'acp' },
        env = {
          NODE_NO_WARNINGS = '1',
          HOME = os.getenv 'HOME',
        },
      },
      ['claude-code'] = {
        ['claude-code'] = {
          command = 'npx',
          args = { '@agentclientprotocol/claude-agent-acp' },
          env = {
            NODE_NO_WARNINGS = '1',
            ANTHROPIC_API_KEY = os.getenv 'ANTHROPIC_API_KEY',
          },
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
    { 'ColinKennedy/mega.cmdparse', dependencies = { 'ColinKennedy/mega.logging' } },
    --- The below dependencies are optional,
    'nvim-mini/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'folke/snacks.nvim', -- for input provider snacks
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
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
