local function tig_show_line(bufnr, lnum)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local out = vim.fn.systemlist(
    { "git", "-C", vim.fs.dirname(file), "blame", "--porcelain", "-L", lnum .. "," .. lnum, "--contents", "-", "--", file },
    vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  )
  local sha = vim.v.shell_error == 0 and out[1] and out[1]:match("^%x+")
  if not sha or sha:match("^0+$") then
    return vim.notify("This line is not committed yet")
  end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  local width, height = math.floor(vim.o.columns * 0.95), math.floor(vim.o.lines * 0.95)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
  })
  vim.fn.jobstart({ "tig", "show", sha }, {
    term = true,
    on_exit = function()
      vim.schedule(function() pcall(vim.api.nvim_win_close, win, true) end)
    end,
  })
  vim.cmd.startinsert()
end

-- days since the commit, newest first, in the theme's colours; anything older is grey
local blame_ages = { { 7, "DiagnosticWarn" }, { 30, "DiagnosticOk" }, { 180, "DiagnosticHint" }, { 365, "DiagnosticInfo" } }

local function blame_author(_, info, ctx)
  local days = (os.time() - info.author_time) / 86400
  local group = "Comment"
  for _, age in ipairs(blame_ages) do
    if days < age[1] then
      group = age[2]
      break
    end
  end
  vim.api.nvim_set_hl(0, ctx.hash_hl_group, { link = group })
  return { { info.author, ctx.hash_hl_group } }, false
end

local blame_ns = vim.api.nvim_create_namespace("blame_authors")

local function repeat_blame_authors(buf)
  local author
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    author = line:match("^%S+ (.+)$") or author
    if author and not line:find(" ") then
      local hl
      for _, m in ipairs(vim.api.nvim_buf_get_extmarks(buf, -1, { i - 1, 0 }, { i - 1, 0 }, { details = true })) do
        if m[4].end_row == i - 1 and m[4].hl_group then
          hl = m[4].hl_group
          break
        end
      end
      vim.api.nvim_buf_set_extmark(buf, blame_ns, i - 1, 0, { virt_text = { { author, hl } }, virt_text_win_col = 2 })
    end
  end
end

return {
  "lewis6991/gitsigns.nvim",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "gitsigns-blame",
      callback = function(ev)
        repeat_blame_authors(ev.buf)
        vim.keymap.set("n", "t", function()
          -- the blamed file sits right of the blame column, line for line
          local source = vim.api.nvim_win_get_buf(vim.fn.win_getid(vim.fn.winnr("l")))
          tig_show_line(source, vim.fn.line("."))
        end, { buffer = ev.buf, nowait = true, desc = "Open commit in tig" })
      end,
    })
  end,
  opts = {
    blame_formatter = blame_author,
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
      map("<leader>gb", gs.blame, "Blame file")
      map("<leader>gB", gs.blame_line, "Blame line")
      map("<leader>gd", gs.diffthis, "Diff file")
      map("<leader>gt", function() tig_show_line(buf, vim.fn.line(".")) end, "Line commit in tig")
    end,
  },
}
