-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Tìm file với telescope
vim.g.mapleader = " "
vim.keymap.set("n", "<space>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>")
vim.keymap.set("n", "<space>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
vim.keymap.set("n", "<space>fh", "<cmd>lua require('telescope.builtin').oldfiles()<CR>")
vim.keymap.set("n", "<space>fr", "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>")
vim.keymap.set("n", "<space>fm", "<cmd>lua require('telescope.builtin').marks()<CR>")
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
