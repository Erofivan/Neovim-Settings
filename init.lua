vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4 
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 250

-- Makes lines with tabs and spaces only completly empty
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "" then
      return
    end

    local ok, lines = pcall(vim.api.nvim_buf_get_lines, 0, 0, -1, false)
    if not ok then
      return
    end

    for i, line in ipairs(lines) do
      if line:match("^%s+$") then
        lines[i] = ""
      end
    end

    pcall(vim.api.nvim_buf_set_lines, 0, 0, -1, false, lines)
  end,
})

-- Removes trailing whitespaces and places empty line at the end of the file
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype ~= "" or vim.bo.binary then
      return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)

    vim.cmd([[keeppatterns %s/\s\+$//e]])

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local n = #lines
    if n == 0 then
      return
    end

    while n > 1 and lines[n] == "" do
      n = n - 1
    end

    local new_lines = vim.list_slice(lines, 1, n)
    table.insert(new_lines, "")

    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)

    local total = vim.api.nvim_buf_line_count(0)
    cursor[1] = math.min(cursor[1], total)
    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
  end,
})

require("config.lazy")

