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
          },
          highlight = { enable = true },
        }
      end,
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
      build = 'cd app && npm install',
      ft = { 'markdown' },
      config = function()
        -- auto-start or other config if desired
      end,
    },
    {
      'mattn/emmet-vim',
      ft = { 'html', 'css', 'javascript', 'typescript', 'tsx', 'vue', 'razor' },
      -- optional settings:
      init = function()
        vim.g.user_emmet_leader_key = ','
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
              accept = '<C-a>', -- Accept suggestion with Ctrl + L
              next = '<C-f>', -- Navigate to next suggestion
              prev = '<C-e>', -- Navigate to previous suggestion
              accept_word = '<C-v>',
            },
          },
        }
      end,
    },
    {
      'zbirenbaum/copilot-cmp',
      after = { 'copilot,lua' },
      suggestion = { enabled = false },
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
        direction = 'float', -- Floating terminal
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
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      icon,
      -- lazy.nvim  -- will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },
}
