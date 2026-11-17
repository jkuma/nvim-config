return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "go", "gomod", "gosum", "gowork",
      "rust", "toml",
      "typescript", "tsx", "javascript", "jsdoc", "json", "html", "css",
      "lua", "luadoc", "vim", "vimdoc", "query",
      "markdown", "markdown_inline", "bash", "yaml", "diff", "regex",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
