local map = vim.keymap.set

map("i", "jk", "<Esc>")

-- [ and ] need AltGr+Shift on a French Mac layout
map({ "n", "x", "o" }, "ç", "[", { remap = true, desc = "Previous ([)" })
map({ "n", "x", "o" }, "à", "]", { remap = true, desc = "Next (])" })

map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostic" })

map("x", "<leader>r", function()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  local escaped = vim.tbl_map(function(l) return vim.fn.escape(l, "\\/") end, lines)
  vim.fn.setreg("/", "\\V\\C" .. table.concat(escaped, "\\n"))
  vim.api.nvim_feedkeys(vim.keycode("<Esc>:%s///g<Left><Left>"), "n", false)
end, { desc = "Replace selection in file" })
