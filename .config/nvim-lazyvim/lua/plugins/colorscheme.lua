return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            float = {
                transparent = true,
                solid = true,
            },
            style = "night",
            transparent = true,
            custom_highlights = function(colors)
                return {
                    CursorLine = { bg = "NONE" },
                    CursorLineNr = { fg = colors.mauve, bg = "NONE" },
                }
            end,
        },
    },
    {
        "catppuccin/nvim",
        lazy = true,
        opts = {
            float = {
                transparent = true,
                solid = true,
            },
            flavour = "mocha",
            transparent_background = true,
            custom_highlights = function(colors)
                return {
                    CursorLine = { bg = "NONE" },
                    CursorLineNr = { fg = colors.mauve, bg = "NONE" },
                }
            end,
        },
    },
    {
        "navarasu/onedark.nvim",
        lazy = true,
        opts = {
            float = {
                transparent = true,
                solid = true,
            },
            style = "darker",
            transparent = true,
            custom_highlights = function(colors)
                return {
                    CursorLine = { bg = "NONE" },
                    CursorLineNr = { fg = colors.mauve, bg = "NONE" },
                }
            end,
        },
    },
}
