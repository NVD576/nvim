return  {
 "catppuccin/nvim", name = "catppuccin", priority = 1000,
  "nvim-lualine/lualine.nvim" ,
  "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" ,
  "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },

}