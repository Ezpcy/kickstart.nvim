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
local configs = require 'lspconfig.configs'

vim.lsp.config('denols', {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
  single_file_support = false,
})

-- vim.lsp.config('ts_ls', {
--   on_attach = on_attach,
--   root_dir = lspconfig.util.root_pattern 'package.json',
--   single_file_support = false,
-- })

-- lspconfig.html.setup {
--   filetypes = { 'html' },
-- }

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
      root_dir = lspconfig.util.root_pattern('.git', 'pom.xml'),
      single_file_support = true,
    },
  }
end

lspconfig.jsp_lsp.setup {}
 ]]
