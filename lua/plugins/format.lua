local prettier = { "prettierd", "prettier", stop_after_first = true }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format" },
    {
      "<leader>tf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
      end,
      desc = "Format on save",
    },
  },
  opts = {
    formatters_by_ft = {
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      lua = { "stylua" },
      javascript = prettier,
      javascriptreact = prettier,
      typescript = prettier,
      typescriptreact = prettier,
      json = prettier,
      css = prettier,
      html = prettier,
      yaml = prettier,
      markdown = prettier,
    },
    formatters = {
      prettierd = { require_cwd = true },
      prettier = { require_cwd = true },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function()
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 1000 }
    end,
  },
}
