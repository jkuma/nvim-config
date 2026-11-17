local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
opt.winborder = "rounded"
opt.showmode = false

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.confirm = true
opt.splitright = true
opt.splitbelow = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.breakindent = true

opt.updatetime = 250
opt.timeoutlen = 400

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
  float = { source = "if_many" },
})
