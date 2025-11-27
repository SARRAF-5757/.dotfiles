return {
  'catppuccin/nvim',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      opts = {
        float = {
          transparent = true,
          solid = true,
        },
        flavour = 'mocha',
        transparent_background = true,
      },
    }

    vim.cmd.colorscheme 'catppuccin'
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
