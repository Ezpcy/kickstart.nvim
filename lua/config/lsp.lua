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

-- Using vim.lsp.config instead of deprecated lspconfig

vim.lsp.config('denols', {
  on_attach = on_attach,
  root_dir = vim.fs.root(0, { 'deno.json', 'deno.jsonc' }),
  single_file_support = false,
})

vim.lsp.config('htmx', {
  cmd = { 'htmx-lsp' }, -- from Mason or PATH
  filetypes = { 'html', 'htmldjango', 'templ', 'php', 'blade', 'twig', 'eex', 'heex', 'vue', 'svelte', 'astro', 'mdx' },
  single_file_support = true,
  root_dir = vim.fs.root(0, { '.git', 'index.html' }),
})

-- For Rafisa
vim.lsp.config('sonarlint', {
  cmd = {
    'sonarlint-language-server',
    '-stdio',
    '-analyzers',
    vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarpython.jar',
    vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarcfamily.jar',
    vim.fn.expand '$MASON/share/sonarlint-analyzers/sonarjava.jar',
  },
  filetypes = { 'java', 'javascript', 'typescript', 'python' },
  root_dir = function(fname)
    return vim.fs.root(fname, {
      'pom.xml',
      'build.gradle',
      'settings.gradle',
      'package.json',
      'pyproject.toml',
      '.git',
    }) or vim.fn.getcwd()
  end,
  settings = {
    sonarlint = {
      connectedMode = {
        servers = {
          {
            serverId = 'Rafisa',
            serverUrl = 'https://sonar.test.rafisa.org',
            token = os.getenv 'RAFISA_SONAR_TOKEN',
          },
        },
      },
    },
  },
})

-- For some reason, sonarlint needs to be started manually
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'java', 'javascript', 'typescript', 'python' },
  callback = function(ev)
    vim.lsp.start {
      name = 'sonarlint',
      cmd = vim.lsp.config.sonarlint.cmd,
      root_dir = vim.lsp.config.sonarlint.root_dir(ev.file),
      settings = vim.lsp.config.sonarlint.settings,
    }
  end,
})

-- vim.lsp.config('ts_ls', {
--   on_attach = on_attach,
--   root_dir = vim.fs.root(0, { 'package.json' }),
--   single_file_support = false,
-- })

-- vim.lsp.config('html', {
--   filetypes = { 'html' },
-- })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.jsp',
  callback = function()
    vim.bo.filetype = 'jsp'
  end,
})

--[[
if not configs.jsp_lsp then
  configs.jsp_lsp = {
    default_config = {
      cmd = { vim.fn.expand '~/Public/jsp-lsp' },
      filetypes = { 'jsp' },
      root_dir = vim.fs.root(0, { '.git', 'pom.xml' }),
      single_file_support = true,
    },
  }
end

vim.lsp.config('jsp_lsp', {})
 ]]
