return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            staticcheck = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              variableTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "rust_analyzer", "vtsls", "eslint", "lua_ls" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local tb = require("telescope.builtin")
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", tb.lsp_definitions, "Definition")
          map("gD", vim.lsp.buf.declaration, "Declaration")
          map("grr", tb.lsp_references, "References")
          map("gri", tb.lsp_implementations, "Implementations")
          map("grt", tb.lsp_type_definitions, "Type definition")
          map("gO", tb.lsp_document_symbols, "Document symbols")
          map("gW", tb.lsp_dynamic_workspace_symbols, "Workspace symbols")
          map("<leader>ca", vim.lsp.buf.code_action, "Code actions")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>th", function()
            local on = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
            vim.lsp.inlay_hint.enable(not on, { bufnr = ev.buf })
          end, "Inlay hints")
        end,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = { ensure_installed = { "goimports", "prettierd", "stylua" } },
  },
}
