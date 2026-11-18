vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

local search_keys = { n = true, N = true, ["*"] = true, ["#"] = true, ["/"] = true, ["?"] = true }

-- search highlights last only while jumping between matches
vim.on_key(function(_, typed)
  if typed == "" or vim.fn.mode() ~= "n" then
    return
  end
  local on = search_keys[vim.fn.keytrans(typed)] or false
  if vim.o.hlsearch ~= on then
    vim.o.hlsearch = on
  end
end, vim.api.nvim_create_namespace("auto_hlsearch"))
