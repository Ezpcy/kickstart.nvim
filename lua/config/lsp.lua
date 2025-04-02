-- ================================================
-- LSP SETTINGS
-- ================================================

-- Additional servers you want to configure:

-- Example: If you want to skip certain servers that your framework auto-installs:
-- local servers_to_skip = { "rust_analyzer", "clangd" }

-- You can override them or do your own setup
-- If you do auto server setup, e.g. with 'mason-lspconfig', you can do something like:
-- require("mason-lspconfig").setup {
--   ensure_installed = { "denols", "tsserver", "rust_analyzer", ... }
-- }

---------------------------------
-- Rust Tools Setup
---------------------------------
local mason_path = vim.fn.stdpath 'data' .. '/mason/'
local codelldb_path = mason_path .. 'bin/codelldb'
local liblldb_path = mason_path .. 'packages/codelldb/extension/lldb/lib/liblldb'
local this_os = vim.loop.os_uname().sysname
if this_os:find 'Windows' then
  codelldb_path = mason_path .. 'packages\\codelldb\\extension\\adapter\\codelldb.exe'
  liblldb_path = mason_path .. 'packages\\codelldb\\extension\\lldb\\bin\\liblldb.dll'
else
  liblldb_path = liblldb_path .. (this_os == 'Linux' and '.so' or '.dylib')
end

local rt_status_ok, rust_tools = pcall(require, 'rust-tools')
if rt_status_ok then
  rust_tools.setup {
    tools = {
      executor = require('rust-tools/executors').termopen,
      reload_workspace_from_cargo_toml = true,
      runnables = { use_telescope = true },
      inlay_hints = {
        auto = true,
        show_parameter_hints = true,
        parameter_hints_prefix = '<-',
        other_hints_prefix = '=>',
      },
    },
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
      on_attach = function(client, bufnr)
        -- typical on_attach code here
      end,
      settings = {
        ['rust-analyzer'] = {
          lens = { enable = true },
          checkOnSave = { enable = true, command = 'clippy' },
        },
      },
    },
  }
end

-- Deno
vim.g.markdown_fenced_languages = {
  'typescript',
  'typescriptreact',
  'javascript',
  'javascriptreact',
  'css',
  'html',
  'json',
  'bash',
  'rust',
  'tsx',
  'jsx',
  'cpp',
  'go',
  'java',
}

local lspconfig = require 'lspconfig'
local jdtls = require 'jdtls'
local home = os.getenv 'HOME'
local workspace_dir = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local root_dir = require('jdtls.setup').find_root {
  '.git',
  'mvnw',
  'gradlew',
  'pom.xml',
  'build.gradle',
} or vim.fn.getcwd()

local bundles =
  vim.split(vim.fn.glob(home .. '/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', 1), '\n')

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
    '-data',
    workspace_dir,
  },

  root_dir = root_dir,

  init_options = {
    bundles = bundles,
  },

  settings = {
    java = {
      project = {
        referencedLibraries = {
          '/usr/share/java/tomcat10/*',
        },
      },
    },
  },

  on_attach = function(client, bufnr)
    jdtls.setup_dap { hotcodereplace = 'auto' }
    jdtls.dap.setup_dap_main_class_configs()
  end,
}

-- START the server:
jdtls.start_or_attach(config)

lspconfig.denols.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
}

require('lspconfig').jdtls = {
  autostart = false,
}

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern 'package.json',
  single_file_support = false,
}

lspconfig.denols.setup {}

lspconfig.html.setup {
  filetypes = { 'html', 'jsp' },
}

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.jsp',
  callback = function()
    vim.bo.filetype = 'jsp'
  end,
})
