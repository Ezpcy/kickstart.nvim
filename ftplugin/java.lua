local jdtls = require 'jdtls'

local home = os.getenv 'HOME'
local workspace_dir = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local root_dir = require('jdtls.setup').find_root {
  '.git',
  'mvnw',
  'gradlew',
  'pom.xml',
  'build.gradle',
  'build.gradle.kts',
  'settings.gradle',
  'settings.gradle.kts',
  'build.xml',
  'src',
}

if root_dir == nil then
  return
end

-- Collect bundles for DAP
local bundles = {}

vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n')
)

vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-test/extension/server/*.jar'), '\n'))

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
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
  settings = {
    java = {
      project = {
        sourcePaths = { 'src' },
        referencedLibraries = {
          '/usr/share/java/tomcat10/*',
        },
      },
    },
  },
  init_options = {
    bundles = bundles,
  },
}

-- Start or attach the LSP
jdtls.start_or_attach(config)

-- Enable debugging
jdtls.setup_dap { hotcodereplace = 'auto' }
