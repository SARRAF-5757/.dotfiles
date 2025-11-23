-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local groups = {
            -- core UI
            "Normal",
            "NormalNC",
            "CursorLine",
            "CursorLineNr",
            "SignColumn",
            "LineNr",

            -- floats
            "NormalFloat",
            "FloatBorder",

            -- trees
            "NvimTreeNormal",
            "NvimTreeNormalNC",
            "NeoTreeNormal",
            "NeoTreeNormalNC",

            -- telescope
            "TelescopeNormal",
            "TelescopeBorder",

            -- statusline/tabline
            "StatusLine",
            "StatusLineNC",
            "TabLine",
            "TabLineFill",
            "TabLineSel",

            -- other windows
            "WinBar",
            "WinBarNC",
        }

        for _, group in ipairs(groups) do
            vim.cmd("hi " .. group .. " guibg=NONE")
        end
    end,
})
