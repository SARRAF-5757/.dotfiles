return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = {
                enabled = false,
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
    },
}
