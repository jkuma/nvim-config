return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
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
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        map("]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("[h", function() gs.nav_hunk("prev") end, "Previous hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gs", gs.stage_hunk, "Stage hunk")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
        map("<leader>gb", gs.blame_line, "Blame line")
        map("<leader>gd", gs.diffthis, "Diff file")
      end,
    },
  },
}
