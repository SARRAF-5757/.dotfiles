-- Highlight, edit, and navigate code

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',

  -- See `:help nvim-treesitter`
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      --  If you're experiencing weird indenting issues, add the language to the list
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  --  Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --  Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}

-- vim: ts=2 sts=2 sw=2 et
