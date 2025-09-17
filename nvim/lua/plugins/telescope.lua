---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
        preview = true,
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      telescope.setup(opts)

      -- Hàm jump tới reference
      local function jump_to_reference(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry.filename then
          vim.cmd("edit " .. vim.fn.fnameescape(entry.filename))
          vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
        end
      end

      -- Keymap grr để show references LSP
      vim.keymap.set("n", "grr", function()
        require("telescope.builtin").lsp_references({
          include_declaration = false,
          show_line = true,
          attach_mappings = function(prompt_bufnr, map)
            map({ "i", "n" }, "<CR>", function() jump_to_reference(prompt_bufnr) end)
            return true
          end,
        })
      end, { desc = "LSP: Show references" })
    end,
  },
}
