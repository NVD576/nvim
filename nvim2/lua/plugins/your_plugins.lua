return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	}
	,
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("onedark").setup({
				style = "cool" -- các style: dark, cool, deep, warm, warmer
			})
			require("onedark").load()
		end
	},  { "jremmen/vim-ripgrep" }, { "nvie/vim-flake8" },
	{ "tpope/vim-commentary" }, { "christoomey/vim-tmux-navigator" },
	{ "ervandew/supertab" }, { "andlrc/rpgle.vim" },
	{ "captbaritone/better-indent-support-for-php-with-html" },
	{ "Pocco81/auto-save.nvim", config = true },
	{
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	config = function()
		require("nvim-web-devicons").setup({
			override_by_extension = {
				css = {
					icon = "", -- Biểu tượng riêng cho .css
					color = "#61afef",
					name = "css"
				}
			},
			default = true -- Hiển thị biểu tượng mặc định nếu không có override
		})
	end
}, {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local api = require("nvim-tree.api")

		require("nvim-tree").setup({
			hijack_netrw = true,
			update_cwd = false,

			on_attach = function(bufnr)
				-- Gán các phím mặc định TRƯỚC
				api.config.mappings.default_on_attach(bufnr)

				-- Sau đó gán phím C riêng của bạn
				vim.keymap.set("n", "C", function()
					local node = api.tree.get_node_under_cursor()
					if node and node.absolute_path and
						 vim.fn.isdirectory(node.absolute_path) == 1 then
						api.tree.change_root(node.absolute_path)
						vim.fn.chdir(node.absolute_path)
						print("CD & Root to: " .. node.absolute_path)
					else
						print("Not a valid directory!")
					end
				end, {
					desc = "nvim-tree: Change root and cd",
					buffer = bufnr,
					noremap = true,
					silent = true
				})
			end
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				if vim.fn.isdirectory("D:/nvd/") == 1 then
					api.tree.change_root("D:/nvd/")
					vim.fn.chdir("D:/nvd/")
					print("Opened nvim-tree at D:/nvd/")
				else
					print("D:/nvd/ not found")
				end
			end
		})
	end
}, {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				layout_strategy = 'horizontal',
				layout_config = {
					horizontal = { preview_width = 0.5, results_width = 0.5 },
					prompt_position = "top",
					preview_cutoff = 1
				},
				sorting_strategy = "ascending",
				mappings = {
					i = { ["<C-d>"] = actions.delete_buffer },
					n = { ["<C-d>"] = actions.delete_buffer }
				}
			},
			pickers = {
				buffers = {
					sort_lastused = true,
					previewer = true,
					mappings = {
						i = { ["<C-d>"] = actions.delete_buffer },
						n = { ["<C-d>"] = actions.delete_buffer }
					}
				}
			}
		})
	end
}, {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c", "cpp", "python", "lua", "html", "css", "javascript",
				"typescript", "php"
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false
			},
			indent = { enable = true }
		})
	end
}, {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "gruvbox",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				icons_enabled = true,
				always_divide_middle = true
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" }
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {}
			},
			tabline = {},
			extensions = { "nvim-tree", "fugitive", "quickfix" }
		})
	end
}, {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				numbers = "ordinal",
				diagnostics = "nvim_lsp",
				show_buffer_close_icons = true,
				show_close_icon = true,
				separator_style = "thin"
			}
		})
	end
},
	{
		"numToStr/Comment.nvim",
		config = function() require("Comment").setup() end
	}, {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true -- dùng tree-sitter để biết ngữ cảnh
		})
	end
}, {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			char = "│" -- hoặc "▏", "┊", "⸽"
		},
		scope = { enabled = true, show_start = true, show_end = true },
		exclude = {
			filetypes = { "help", "dashboard", "nvimtree" },
			buftypes = { "terminal", "nofile" }
		}
	}
}, {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	config = function() require("mason").setup() end
}, 

{
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig"
  },
  config = function()
    require("mason").setup()

		require("mason-lspconfig").setup({
		  ensure_installed = {
		    -- "pyright",
		    -- "html",
		    -- "cssls",
		    "ts_ls",  -- TypeScript/JavaScript LSP
		    "eslint"     -- ESLint
		  },
		--   automatic_installation = false
		})

    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

    -- Cấu hình clangd riêng
    lspconfig.clangd.setup({
      cmd = {
        "C:/msys64/ucrt64/bin/clangd.exe",
        "--header-insertion=never",
        "--query-driver=C:/msys64/ucrt64/bin/*"
      },
      root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git") or
        function(fname)
          return vim.fn.fnamemodify(fname, ":p:h")
        end
    })

  end
}
, {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip"
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end
			},
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<CR>"] = cmp.mapping.confirm({ select = true })
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, { name = "luasnip" }, { name = "buffer" },
				{ name = "path" }
			})
		})
	end
},
{
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
  config = function()
    require("smoothcursor").setup({
      type = "matrix",
      fancy = {
        enable = true,
        head = { text = ">" },
        body = {
          { text = "/", hl = "SmoothCursorRed" },
          { text = "/", hl = "SmoothCursorOrange" },
          { text = "/", hl = "SmoothCursorYellow" },
          { text = "/", hl = "SmoothCursorGreen" },
          { text = "/", hl = "SmoothCursorBlue" },
        },
        tail = { text = ".", hl = "SmoothCursor" },
      },
    })

    vim.cmd([[
      highlight SmoothCursor       guifg=#FFD700
      highlight SmoothCursorRed    guifg=#FF5555
      highlight SmoothCursorOrange guifg=#FFB86C
      highlight SmoothCursorYellow guifg=#F1FA8C
      highlight SmoothCursorGreen  guifg=#50FA7B
      highlight SmoothCursorBlue   guifg=#8BE9FD
    ]])
  end,
}

}
