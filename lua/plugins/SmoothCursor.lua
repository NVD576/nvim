-- ~/.config/nvim/lua/plugins/cursor-trail.lua
return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      cursor_color = "#f9f8f6",  -- Màu sáng của bạn

      -- === SIÊU MƯỢT: TĂNG FPS + GIẢM LAG ===
      update_interval = 16,       -- 120 FPS (từ 16 → 8)
      max_trail_length = 8,      -- Giới hạn độ dài vệt (giảm tính toán)

      -- === TỐI ƯU THAM SỐ CHO MƯỢT ===
      stiffness = 0.7,           -- Cứng vừa → phản hồi nhanh
      trailing_stiffness = 0.25, -- Đuôi mảnh, không kéo dài
      damping = 0.75,            -- Mờ nhanh → không chồng chéo
      trailing_exponent = 2,     -- Đuôi siêu ngắn → mượt hơn

      gamma = 0.15,              -- Sáng nhẹ → không chói

      -- === ẨN CON TRỎ THẬT 100% ===
      hide_target_hack = true,
      never_draw_over_target = true,
      draw_target = false,

      -- === TỐI ƯU HIỆU SUẤT ===
      smear_in_insert_mode = false,
      smear_between_buffers = false,

      -- === BẬT TỐI ƯU NỘI BỘ (nếu plugin hỗ trợ) ===
      -- force_redraw = false,   -- Tắt nếu có (giảm lag)
    },
  },
}
