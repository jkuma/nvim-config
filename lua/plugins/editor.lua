return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = { view_options = { show_hidden = true } },
    keys = { { "-", "<cmd>Oil<CR>", desc = "Parent directory" } },
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
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep project" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
      { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume last search" },
    },
    config = function()
      require("telescope").setup({})
      require("telescope").load_extension("fzf")
    end,
  },
}
