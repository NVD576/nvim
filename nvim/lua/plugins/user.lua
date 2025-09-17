---@type LazySpec
return {
{ "folke/snacks.nvim", enabled = false }, 
  -- Theme đẹp: Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },

  -- Dashboard khởi động
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        " ███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██╔════╝██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║█████╗  ██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("g", "󰊄  Find Text", ":Telescope live_grep<CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      dashboard.section.footer.val = "🚀 Welcome to AstroNvim with a fresh UI!"
      alpha.setup(dashboard.opts)
    end,
  },

  -- Statusline hiện đại
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators = { left = "", right = "" },
          component_separators = "|",
        },
      })
    end,
  },

  -- Icon sinh động
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Animation mượt
{
  "echasnovski/mini.animate",
  event = "VeryLazy",
  config = function()
    local animate = require("mini.animate")
    animate.setup({
      cursor = {
        enable = true,
        -- timing = animate.gen_timing.linear({ duration = 50, unit = "total" }), -- con trỏ nhanh hơn
        timing = animate.gen_timing.cubic({ easing = "out", duration = 120, unit = "total" }),
      },
      scroll = {
        enable = false,
        -- timing = animate.gen_timing.linear({ duration = 20, unit = "total" }), -- lăn mượt nhưng nhanh hơn
      },
      resize = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
      },
      open = { enable = false },
      close = { enable = false },
    })
  end,
},




 -- 🖱️ Con trỏ mượt khi cuộn
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("neoscroll").setup({
        easing_function = "cubic",  -- cubic easing mượt hơn quadratic
        hide_cursor = true,         -- ẩn con trỏ khi cuộn
        stop_eof = true,            -- dừng cuộn ở cuối file
        respect_scrolloff = false,  -- bỏ qua scrolloff để cuộn tự do
        cursor_scrolls_alone = true -- cho con trỏ đi cùng animation
      })
    end,
  },

  -- 🔥 Hiệu ứng con trỏ di chuyển
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function()
      require("smoothcursor").setup({
        autostart = true,
        cursor = "", -- icon con trỏ
        texthl = "SmoothCursor",
        type = "default", -- bạn có thể đổi sang exp/expand/shrink
        fancy = {
          enable = true,
          head = { cursor = "▷", texthl = "SmoothCursor" },
          body = { { cursor = "•", texthl = "SmoothCursor" } },
        },
      })
    end,
  },
}
