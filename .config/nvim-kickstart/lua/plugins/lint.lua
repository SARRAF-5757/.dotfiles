return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      cpp = { 'clangd' },
    }

    -- Create autocommand which carries out the actual linting on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter within the LSP pop-ups that describe the hovered symbol using Markdown.
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
    })
  end,
}
