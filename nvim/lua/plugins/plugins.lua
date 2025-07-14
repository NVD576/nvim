-- ~/.config/nvim/lua/plugins.lua (trên Windows là: AppData\Local\nvim\lua\plugins.lua)
return {
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

{
  "hrsh7th/nvim-cmp",
 enabled = true,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    require("cmp").setup({})
  end,
},


    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
    },    
  
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
        require("lualine").setup()
      end },
  
     { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
         require("nvim-treesitter.configs").setup {
          highlight = { enable = true },
           ensure_installed = { "python", "javascript", "lua", "cpp"}
        }
      end },
  
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  
    {
      "stevearc/conform.nvim",
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            python = { "black" },
            javascript = { "prettier" },
            cpp = { "clang-format" },
          },
        })
      end,
    },
  
    "neovim/nvim-lspconfig",
    -- "hrsh7th/nvim-cmp",
    -- "hrsh7th/cmp-nvim-lsp",
    -- "L3MON4D3/LuaSnip",
  }
  