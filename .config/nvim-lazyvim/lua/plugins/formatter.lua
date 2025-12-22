return {
    "stevearc/conform.nvim",
    opts = {
        formatters = {
            prettier = {
                prepend_args = { "--print-width", "180" },
            },
        },
    },
}
