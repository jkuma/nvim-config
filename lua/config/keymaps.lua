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
map("n", "<leader>tb", function() vim.o.background = vim.o.background == "dark" and "light" or "dark" end, { desc = "Light or dark background" })

local function search_selection()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  local escaped = vim.tbl_map(function(l) return vim.fn.escape(l, "\\/") end, lines)
  local pattern = "\\V\\C" .. table.concat(escaped, "\\n")
  -- whole lines only match whole lines
  if vim.fn.mode() == "V" then
    pattern = "^" .. pattern .. "\\m$"
  end
  vim.fn.setreg("/", pattern)
end

map("x", "<leader>r", function()
  search_selection()
  vim.api.nvim_feedkeys(vim.keycode("<Esc>:%s///g<Left><Left>"), "n", false)
end, { desc = "Replace selection in file" })

map("x", "<leader>R", function()
  search_selection()
  vim.cmd("normal! \27")
  local view = vim.fn.winsaveview()
  vim.cmd([[%s//\=join(getreg('0', 1, 1), "\n")/ge]])
  vim.fn.winrestview(view)
end, { desc = "Replace selection in file with last yank" })
