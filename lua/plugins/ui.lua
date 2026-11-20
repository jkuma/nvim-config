local theme_file = vim.fn.stdpath("state") .. "/theme.json"

local function apply_saved_theme()
  local ok, saved = pcall(function() return vim.json.decode(vim.fn.readfile(theme_file)[1]) end)
  if ok and saved.background then
    vim.o.background = saved.background
  end
  if not (ok and pcall(vim.cmd.colorscheme, saved.colorscheme)) then
    vim.cmd.colorscheme("tokyonight-night")
  end
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      local theme = { colorscheme = vim.g.colors_name, background = vim.o.background }
      vim.fn.writefile({ vim.json.encode(theme) }, theme_file)
    end,
  })
end

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = apply_saved_theme,
  },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "nickkadutskyi/jb.nvim", lazy = true },
  { "xiantang/darcula-dark.nvim", lazy = true },
  {
    "nvim-mini/mini.nvim",
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
      require("mini.pairs").setup()
      require("mini.statusline").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Search" },
        { "<leader>g", group = "Git" },
        { "<leader>t", group = "Toggles" },
      },
    },
  },
}
