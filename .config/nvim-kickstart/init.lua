-- [[Vim Settings]]
vim.g.mapleader = ' ' -- See `:help mapleader`
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true -- Set to true if a Nerd Font is installed

-- [[Add Modular Files]]
require 'vim-config'
require 'keymaps'
require 'autocmds'
require 'lazy-setup'

-- See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
