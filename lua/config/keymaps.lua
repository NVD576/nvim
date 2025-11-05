local map = vim.keymap.set

-- Compile & Run cho nhiều ngôn ngữ (Windows)

map("n", "<F5>", function()
  vim.cmd("w") -- Lưu file trước

  local ft = vim.bo.filetype -- Lấy loại file hiện tại

  local cmd = ""

  if ft == "cpp" then
    cmd = "g++ % -o %< && %<.exe"
  elseif ft == "c" then
    cmd = "gcc % -o %< && %<.exe"
  elseif ft == "python" then
    cmd = "python %"
  elseif ft == "javascript" then
    cmd = "node %"
  elseif ft == "java" then
    cmd = "javac % && java %<"
  else
    print("❌ Không hỗ trợ chạy file loại: " .. ft)

    return
  end

  -- Mở terminal ở split và chạy lệnh

  vim.cmd("botright split | terminal " .. cmd)

  vim.cmd("startinsert")
end, { desc = "Compile & Run (tự động nhận diện ngôn ngữ)" })

map("n", "<C-a>", "<cmd>normal! ggVG<CR>", { desc = "Select all", noremap = true })

-- map("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard", noremap = true, silent = true })

-- jk để thoát Insert Mode

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
