-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking text
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Set everything to transparent
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Set UI element colors to NONE so that transparency can take effect',
  callback = function()
    local groups = {
      -- core UI
      'Normal',
      'NormalNC',
      'CursorLine',
      'CursorLineNr',
      'SignColumn',
      'LineNr',

      -- floats
      'NormalFloat',
      'FloatBorder',

      -- trees
      'NvimTreeNormal',
      'NvimTreeNormalNC',
      'NeoTreeNormal',
      'NeoTreeNormalNC',

      -- telescope
      'TelescopeNormal',
      'TelescopeBorder',

      -- statusline/tabline
      'StatusLine',
      'StatusLineNC',
      'TabLine',
      'TabLineFill',
      'TabLineSel',

      -- other windows
      'WinBar',
      'WinBarNC',
    }

    for _, group in ipairs(groups) do
      vim.cmd('hi ' .. group .. ' guibg=NONE')
    end
  end,
})
