return {
    "Djancyp/better-comments.nvim",
    event = "VeryLazy",
    config = function()
        require("better-comment").Setup({
            tags = {
                {
                    name = "TODO",
                    fg = "#000000",
                    bg = "#f4cc29",
                    bold = false,
                },
                {
                    name = "!",
                    fg = "#ff0000",
                    bg = "",
                    bold = true,
                },
                {
                    name = "*",
                    fg = "#ff8C00",
                    bg = "",
                    bold = true,
                },
                {
                    name = "#",
                    fg = "#00ffd2",
                    bg = "",
                    bold = true,
                },
                {
                    name = "?",
                    fg = "#FF69B4",
                    bg = "",
                    bold = true,
                },
                {
                    name = "@",
                    fg = "#8371ff",
                    bg = "",
                    bold = true,
                },
            },
        })
    end,
}
