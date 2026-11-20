local case_modes = {
  { flag = "--smart-case", label = "smart case" },
  { flag = "--case-sensitive", label = "case sensitive" },
  { flag = "--ignore-case", label = "ignore case" },
}

local function live_grep(mode, text)
  mode = mode or 1
  require("telescope.builtin").live_grep({
    prompt_title = "Grep (" .. case_modes[mode].label .. ")",
    default_text = text,
    additional_args = { case_modes[mode].flag },
    attach_mappings = function(_, map)
      map({ "i", "n" }, "<C-s>", function(prompt_bufnr)
        local state = require("telescope.actions.state")
        local line = state.get_current_line()
        local picker = state.get_current_picker(prompt_bufnr)
        -- the replaced search stays out of the previous-searches list
        if type(picker.cache_picker) == "table" then
          picker.cache_picker.disabled = true
        end
        require("telescope.actions").close(prompt_bufnr)
        live_grep(mode % #case_modes + 1, line)
      end, { desc = "Cycle case sensitivity" })
      return true
    end,
  })
end

return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = { view_options = { show_hidden = true } },
    keys = { { "-", "<cmd>Oil<CR>", desc = "Parent directory" } },
  },
  {
    "nvim-tree/nvim-tree.lua",
    keys = { { "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", desc = "File tree" } },
    opts = {
      hijack_netrw = false,
      hijack_directories = { enable = false },
      update_focused_file = { enable = true },
      view = { width = 35 },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Files" },
      { "<leader>fg", function() live_grep() end, desc = "Grep project" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume last search" },
      { "<leader>fp", "<cmd>Telescope pickers<CR>", desc = "Previous searches" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          cache_picker = { num_pickers = 20, ignore_empty_prompt = true },
          layout_strategy = "vertical",
          layout_config = {
            vertical = { width = 0.95, height = 0.95, preview_height = 0.6, preview_cutoff = 1 },
          },
          mappings = {
            i = {
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-Down>"] = actions.cycle_history_next,
            },
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
}
