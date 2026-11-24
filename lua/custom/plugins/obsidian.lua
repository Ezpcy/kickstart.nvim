return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- use latest release, remove to use latest commit
  ft = 'markdown',
  cmd = 'Obsidian', -- also load when running :Obsidian from a non-Markdown buffer
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    ui = {
      enable = false,
    },
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = 'personal',
        path = '~/ObsidianVault',
      },
    },
    frontmatter = { enabled = false },
    note_id_func = function(title) return title or os.date '%Y%m%d%H%M' end,
    templates = { folder = '_templates/nvim', date_format = 'DD.MM.YYYY' },
    note = { template = 'default.md' },
    daily_notes = {
      folder = '02-Areas/Journal',
      date_format = 'YYYY/MM/DD ddd',
      template = 'daily.md',
      default_tags = {},
      workdays_only = false,
    },
    attachments = {
      folder = './x_ressources',
    },
    link = {
      style = "markdown"
    }
  },
}
