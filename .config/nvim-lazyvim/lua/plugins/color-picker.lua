return {
    "eero-lehtinen/oklch-color-picker.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
        {
            "<leader>cc",
            function()
                require("oklch-color-picker").pick_under_cursor()
            end,
            desc = "Color Picker",
        },
    },
    opts = {
        highlight = {
            style = "virtual_left",
            virtual_text = " ",
        },
    },
}
