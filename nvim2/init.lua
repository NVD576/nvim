-- ==== Load Lazy.nvim nếu chưa tồn tại ====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Nhánh ổn định mới nhất
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Tắt LSP client nếu không còn buffer thuộc nó
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local active_clients = vim.lsp.get_clients()
    for _, client in pairs(active_clients) do
      local attached_buffers = vim.lsp.get_buffers_by_client_id(client.id)
      if #attached_buffers == 0 then
        client.stop()
      end
    end
  end,
})


-- ==== Gọi cấu hình ====
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("lazy").setup("plugins") 
