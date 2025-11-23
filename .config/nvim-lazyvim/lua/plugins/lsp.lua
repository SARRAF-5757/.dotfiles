return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--clang-tidy=0",
                        --"--completion-style=bundled",
                        --"--header-insertion=never",
                    },
                },
            },
        },
    },
}
