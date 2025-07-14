-- File: lua/plugins/lazy.lua
return {
    {
      "Zeioth/compiler.nvim",
      cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
      dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
      opts = {},
      config = function()
        vim.api.nvim_set_keymap('n', '<F6>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<S-F6>', "<cmd>CompilerStop<cr><cmd>CompilerRedo<cr>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
      end
    },
    {
      "stevearc/overseer.nvim",
      commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      opts = {
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          default_detail = 1
        },
      },
    },
    -- bạn có thể thêm các plugin khác ở đây
  }
  