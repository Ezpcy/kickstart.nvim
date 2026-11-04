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

-- (rust-tools.nvim removed: plugin not installed and archived upstream; rust_analyzer is auto-enabled by mason-lspconfig)

vim.g.markdown_fenced_languages = {}

-- Using vim.lsp.config instead of deprecated lspconfig

vim.lsp.config('denols', {
  root_markers = { 'deno.json', 'deno.jsonc' },
})

vim.lsp.config('htmx', {
  cmd = { 'htmx-lsp' }, -- from Mason or PATH
  filetypes = { 'html', 'htmldjango', 'templ', 'php', 'blade', 'twig', 'eex', 'heex', 'vue', 'svelte', 'astro', 'mdx' },
  root_markers = { '.git', 'index.html' },
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
  callback = function() vim.bo.filetype = 'jsp' end,
})

-- jdtls
vim.lsp.config('jdtls', {
  settings = {
    java = {
      project = {
        referencedLibraries = {
          '/usr/share/java/tomcat10/*',
        },
      },
    },
  },
})

vim.lsp.config('tinymist', {
  root_markers = { 'main.typ', '.git' },
})
