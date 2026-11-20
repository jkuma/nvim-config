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

local themes = {
  "tokyonight-night", "tokyonight-storm", "tokyonight-moon", "tokyonight-day",
  "jb", "darcula-dark", "darcula-solid", "dracula", "gruvbox",
}

local function pick_theme()
  local before, background = vim.g.colors_name, vim.o.background
  local state, actions = require("telescope.actions.state"), require("telescope.actions")
  local picker = require("telescope.pickers").new({}, {
    prompt_title = "Colour theme",
    finder = require("telescope.finders").new_table({
      results = vim.list_extend({ before }, vim.tbl_filter(function(t) return t ~= before end, themes)),
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        if state.get_selected_entry() then
          before = nil
        end
        actions.close(prompt_bufnr)
      end)
      return true
    end,
  })
  local set_selection, close_windows = picker.set_selection, picker.close_windows
  function picker:set_selection(row)
    set_selection(self, row)
    local entry = state.get_selected_entry()
    if entry then
      vim.cmd.colorscheme(entry.value)
    end
  end
  function picker:close_windows(status)
    close_windows(self, status)
    if before then
      vim.o.background = background
      vim.cmd.colorscheme(before)
    end
  end
  picker:find()
end

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = apply_saved_theme,
    keys = {
      { "<leader>tc", pick_theme, desc = "Colour theme" },
      {
        "<leader>tb",
        function() vim.o.background = vim.o.background == "dark" and "light" or "dark" end,
        desc = "Light or dark background",
      },
    },
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
