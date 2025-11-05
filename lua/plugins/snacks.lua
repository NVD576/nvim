return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    input = {
      enabled = true, -- Giữ snacks.input
      -- Tăng width để tránh wrap path
      win = {
        width = 60,
      },
    },
    picker = {
      enabled = true,
      actions = {
        -- Override rename action cho explorer

        explorer_rename = function(picker, item)
          if not item then
            return
          end

          local Tree = require("snacks.explorer.tree")
          local actions = require("snacks.explorer.actions")
          local old_name = vim.fn.fnamemodify(item.file, ":t") -- Tên cũ
          local parent_dir = vim.fn.fnamemodify(item.file, ":h") -- Thư mục cha

          Snacks.input({
            prompt = "Rename: ",
            default = old_name,
            width = 60,
          }, function(new_name)
            if not new_name or new_name == "" or new_name == old_name then
              return
            end

            local new_path = vim.fs.normalize(parent_dir .. "/" .. new_name)
            local uv = vim.uv or vim.loop

            -- Kiểm tra nếu đường dẫn mới là chính nó hoặc là thư mục con
            if new_path == item.file or new_path:find(item.file .. "/") == 1 then
              Snacks.notify.error("❌ Không thể đổi tên thành chính nó hoặc thư mục con")
              return
            end

            -- Kiểm tra file đã tồn tại
            if uv.fs_stat(new_path) then
              Snacks.notify.warn("⚠️ Đã tồn tại: " .. new_path)
              return
            end

            -- Thực hiện rename
            local ok, err = uv.fs_rename(item.file, new_path)
            if not ok then
              Snacks.notify.error("❌ Rename thất bại: " .. (err or "unknown error"))
              return
            end

            -- Refresh tree + update picker
            Tree:refresh(parent_dir)
            actions.update(picker, { target = new_path })

            -- Gọi LSP rename nếu có
            local ok_lsp, rename = pcall(require, "snacks.rename")
            if ok_lsp then
              rename.on_rename_file(item.file, new_path)
            end
          end)
        end,
      },
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["r"] = "explorer_rename", -- Gán r cho action mới
              },
            },
          },
        },
      },
    },
  },
}
