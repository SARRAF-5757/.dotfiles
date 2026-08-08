return {
    "neovim/nvim-lspconfig",
    opts = {
        inlay_hints = {
            enabled = false,
        },
        diagnostics = {
            virtual_text = false,
        },
        servers = {
            clangd = {
                cmd = {
                    "clangd",
                    "--clang-tidy=0",
                },
            },
        },
    },
}
