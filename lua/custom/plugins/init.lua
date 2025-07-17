return {
  {
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate', -- updates parsers automatically
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = {
            'bash',
            'c',
            'cpp',
            'css',
            'javascript',
            'lua',
            'python',
            'rust',
            'tsx',
            'typescript',
            'yaml',
            'java',
          },
          highlight = { enable = true, additional_vim_regex_highlighting = false },
          indent = { enable = true },
        }
      end,
    },
    {
      'SmiteshP/nvim-navic',
      dependencies = 'neovim/nvim-lspconfig',
      config = function()
        require('nvim-navic').setup {
          highlight = true,
          separator = ' → ', -- Change separator if needed
          depth_limit = 3, -- Limits how deep the hierarchy shows
        }
      end,
    },
    {
      'simrat39/symbols-outline.nvim',
      config = function()
        require('symbols-outline').setup()
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = function()
        require('treesitter-context').setup {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          multiwindow = false, -- Enable multiwindow support.
          max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 20, -- Maximum number of lines to show for a single context
          trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20, -- The Z-index of the context window
          on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        }
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
          -- null_ls = {
          --  enabled = true,
          -- name = 'crates.nvim',
          --},
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
      -- build = 'cd app && npm install',
      ft = { 'markdown' },
      config = function()
        -- auto-start or other config if desired
      end,
    },
    {
      'mattn/emmet-vim',
      ft = { 'html', 'css', 'javascript', 'typescript', 'tsx', 'vue', 'razor', 'jsp', 'xml' },
      -- optional settings:
      init = function()
        vim.cmd [[
    autocmd FileType jsp EmmetInstall
    autocmd FileType jsp let g:user_emmet_settings = {
          \ 'jsp' : {
          \     'extends' : 'html',
          \ }
          \ }
    ]]
        vim.g.user_emmet_leader_key = '<C-x>'
        vim.g.user_emmet_mode = 'n'
      end,
    },

    -- 4) Copilot
    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      config = function()
        require('copilot').setup {
          panel = { enabled = true },
          suggestion = {
            enabled = true,
            auto_trigger = true,
            keymap = {
              accept = '<C-a>',
              accept_word = '<S-Tab>',
              next = '<C-g>',
              prev = '<C-e>',
            },
          },
          filetypes = {
            yml = true,
            yaml = true,
            markdown = true,
          },
        }
      end,
    },
    {
      'zbirenbaum/copilot-cmp',
      after = { 'copilot,lua' },
      suggestion = { enabled = true },
      config = function()
        require('copilot_cmp').setup {
          suggestion = { enabled = true },
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
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for roslyn
        'tris203/rzls.nvim',
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require('rzls').setup {}
        end,
      },
    },
    config = function()
      require('roslyn').setup {
        args = {
          '--stdio',
          '--logLevel=Information',
          '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator='
            .. vim.fs.joinpath(vim.fn.stdpath 'data' --[[@as string]], 'mason', 'packages', 'roslyn', 'libexec', 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
          '--razorDesignTimePath=' .. vim.fs.joinpath(
            vim.fn.stdpath 'data' --[[@as string]],
            'mason',
            'packages',
            'rzls',
            'libexec',
            'Targets',
            'Microsoft.NET.Sdk.Razor.DesignTime.targets'
          ),
        },
        ---@diagnostic disable-next-line: missing-fields
        config = {
          handlers = require 'rzls.roslyn_handlers',
          settings = {
            ['csharp|inlay_hints'] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ['csharp|code_lens'] = {
              dotnet_enable_references_code_lens = true,
            },
          },
        },
      }
    end,
    init = function()
      -- we add the razor filetypes before the plugin loads
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        direction = 'horizontal', -- Floating terminal
        float_opts = {
          border = 'single', -- "single", "double", "shadow", "curved"
          title_pos = 'center', -- Position title in center (Optional)
        },
        open_mapping = [[<Space>te]],
        close_on_exit = true, -- Close the terminal when process exits
        shade_terminals = false, -- Disable background shading
      }
    end,
  },
  -- {
  --   'romgrk/barbar.nvim',
  --   dependencies = {
  --     'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
  --     'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  --   },
  --   init = function()
  --     vim.g.barbar_auto_setup = false
  --   end,
  --   opts = {
  --     icon,
  --     -- lazy.nvim  -- will automatically call setup for you. put your options here, anything missing will use the default:
  --     -- animation = true,
  --     -- insert_at_start = true,
  --     -- …etc.
  --   },
  --   version = '^1.0.0', -- optional: only update when a new 1.x version is released
  -- },
  { 'mg979/vim-visual-multi' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'hrsh7th/cmp-buffer', -- Buffer source for nvim-cmp
      'hrsh7th/cmp-path', -- Path completions
      'hrsh7th/cmp-cmdline', -- Cmdline completions
      -- any other sources you want
    },
    event = 'InsertEnter',
    config = function()
      require('cmp').setup {}
    end,
  },

  { 'mfussenegger/nvim-jdtls', ft = 'java', dependencies = { 'nvim-dap' } },
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    },
  },
}
