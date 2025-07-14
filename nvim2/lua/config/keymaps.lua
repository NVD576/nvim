local map = vim.keymap.set

map("n", "<space>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
map("n", "<space>f", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Focus File Tree" })

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" })
map("n", "<leader>d", "<cmd>bd<CR>", { desc = "Delete Buffer" })
map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>e", ":Telescope diagnostics<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>o", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>c", "<cmd>Telescope commands<CR>", { desc = "Telescope Commands" })

-- vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>s", function()
	vim.cmd("source $MYVIMRC") -- Reload init.lua
	vim.cmd("Lazy sync")     -- Đồng bộ lại plugin
	print("✅ Reloaded init.lua and synced plugins")
end, { desc = "Reload init.lua & Lazy plugins" })

vim.keymap.set("n", "<A-w>", function()
	vim.wo.wrap = not vim.wo.wrap
	print("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"))
end, { noremap = true, silent = true, desc = "Toggle wrap" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
-- ALT + a để mở cmd.exe trong terminal nổi (floating terminal)

-- Đặt biến toàn cục để quản lý các cửa sổ terminal
_G.cmd_git = _G.cmd_git or { win = nil, buf = nil }
_G.cmd_term = _G.cmd_term or { win = nil, buf = nil }

local cmd_git = _G.cmd_git
local cmd_term = _G.cmd_term

-- PowerShell terminal - Alt + a
vim.keymap.set({ "n", "i", "v", "t" }, "<A-a>", function()
	if cmd_term.win and vim.api.nvim_win_is_valid(cmd_term.win) then
		vim.api.nvim_win_hide(cmd_term.win)
		cmd_term.win = nil
		return
	end

	if not cmd_term.buf or not vim.api.nvim_buf_is_valid(cmd_term.buf) then
		cmd_term.buf = vim.api.nvim_create_buf(false, true)

		vim.api.nvim_buf_call(cmd_term.buf, function()
			vim.fn.termopen(
				{ "C:\\Program Files\\PowerShell\\7\\pwsh.exe" }, -- Thay đổi nếu bạn dùng PowerShell 5
				{
					cwd = vim.fn.getcwd(),
					on_exit = function()
						cmd_term.buf = nil
						cmd_term.win = nil
					end
				}
			)
		end)
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.6)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	cmd_term.win = vim.api.nvim_open_win(cmd_term.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded"
	})

	vim.cmd("startinsert")
end, { noremap = true, silent = true, desc = "Toggle PowerShell Floating Terminal" })

-- LazyGit terminal - Alt + g
vim.keymap.set({ "n", "i", "v", "t" }, "<A-g>", function()
	if cmd_git.win and vim.api.nvim_win_is_valid(cmd_git.win) then
		vim.api.nvim_win_hide(cmd_git.win)
		cmd_git.win = nil
		return
	end

	if not cmd_git.buf or not vim.api.nvim_buf_is_valid(cmd_git.buf) then
		cmd_git.buf = vim.api.nvim_create_buf(false, true)

		vim.api.nvim_buf_call(cmd_git.buf, function()
			vim.fn.termopen("lazygit", {
				cwd = vim.fn.getcwd(),
				on_exit = function()
					cmd_git.buf = nil
					cmd_git.win = nil
				end
			})
		end)
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	cmd_git.win = vim.api.nvim_open_win(cmd_git.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded"
	})

	vim.cmd("startinsert")

end, { noremap = true, silent = true, desc = "Toggle LazyGit Floating Terminal" })


local function format_and_restore(mode)
	if mode == "i" or mode == "v" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	end
	vim.lsp.buf.format({ async = true })
	if mode == "i" then vim.api.nvim_feedkeys("a", "n", false) end
end

vim.keymap.set("n", "<C-f>", function() format_and_restore("n") end,
	{ desc = "Format (normal)" })
vim.keymap.set("i", "<C-f>", function() format_and_restore("i") end,
	{ desc = "Format (insert)" })
vim.keymap.set("v", "<C-f>", function() format_and_restore("v") end,
	{ desc = "Format (visual)" })

vim.keymap.set("n", "<C-r>", function()
	local current_word = vim.fn.expand("<cword>")
	local new_name = vim.fn.input("Rename '" .. current_word .. "' to: ")
	if new_name ~= "" and new_name ~= current_word then
		vim.cmd(":%s/\\<" .. current_word .. "\\>/" .. new_name .. "/g")
		print("Renamed " .. current_word .. " to " .. new_name)
	else
		print("Rename canceled or same name")
	end
end, { desc = "Refactor: Rename word under cursor" })

-- Copy (Ctrl+C in visual mode)
vim.keymap.set("v", "<C-c>", '"+y', {
	noremap = true,
	silent = true,
	desc = "Copy to system clipboard"
})

-- Paste (Ctrl+V in normal/visual/insert mode)
vim.keymap.set("n", "<C-v>", '"+p',
	{ noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set("v", "<C-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true })

-- Cut (Ctrl+X in visual mode)
vim.keymap.set("v", "<C-x>", '"+d', {
	noremap = true,
	silent = true,
	desc = "Cut to system clipboard"
})

-- Undo (Ctrl+Z in normal/insert mode)
vim.keymap.set({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>",
	{ noremap = true, silent = true })

-- Redo (Ctrl+Y in normal/insert mode)
vim.keymap.set({ "n", "i" }, "<C-y>", "<Cmd>redo<CR>",
	{ noremap = true, silent = true })

vim.keymap.set({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG",
	{ noremap = true, silent = true, desc = "Select all" })

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local cmd = nil

		if ft == "javascript" then
			cmd = ":w<CR>:!node %<CR>"
		elseif ft == "python" then
			cmd = ":w<CR>:!python %<CR>"
		elseif ft == "lua" then
			cmd = ":w<CR>:!lua %<CR>"
		elseif ft == "cpp" then
			cmd = ":w<CR>:!g++ % -o %<.exe && %<.exe<CR>"
		elseif ft == "c" then
			cmd = ":w<CR>:!gcc % -o %<.exe && %<.exe<CR>"
		elseif ft == "typescript" then
			cmd = ":w<CR>:!ts-node %<CR>"
		end

		if cmd then
			vim.keymap.set("n", "<F2>", cmd, {
				buffer = args.buf,
				noremap = true,
				silent = true,
				desc = "Run current file"
			})
		end
	end
})
