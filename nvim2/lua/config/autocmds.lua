-- Tự động xóa khoảng trắng cuối dòng khi lưu
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

vim.o.updatetime = 250  -- thời gian trễ để hiện lỗi (ms)

vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]]
