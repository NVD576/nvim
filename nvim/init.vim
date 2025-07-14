" -------------------------- Plugin manager -------------------------
call plug#begin()

" --- Core & UI ------------------------------------------------------
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'goolord/alpha-nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'morhetz/gruvbox'
Plug 'MunifTanjim/nui.nvim'
Plug 'folke/which-key.nvim'
Plug 'unblevable/quick-scope'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }


" --- LSP / Completion ----------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'

" --- File explorer --------------------------------------------------
Plug 'nvim-tree/nvim-tree.lua'

" --- Fuzzy finder ---------------------------------------------------
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-frecency.nvim'

" --- Syntax & Treesitter -------------------------------------------
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'sheerun/vim-polyglot'
Plug 'HerringtonDarkholme/yats.vim'

" --- Dev helpers / tự thêm -----------------------------------------
Plug 'windwp/nvim-autopairs'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'nvie/vim-flake8'
Plug 'andlrc/rpgle.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-commentary'
Plug 'captbaritone/better-indent-support-for-php-with-html'
Plug 'ervandew/supertab'

call plug#end()

" ========================= Basic settings ==========================
set encoding=utf-8
set number
set mouse=a
set autoindent
set cindent
set tabstop=3 shiftwidth=3  smartindent
set nowrap incsearch autoread noswapfile
set guifont=SpaceMono\ NF:h12
set guicursor=a:blinkon0
syntax on | filetype plugin indent on
set termguicolors | colorscheme gruvbox
let g:AutoPairsMapCR = 1


if has('win32') || has('win64')
  set shell=powershell.exe
  set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
  set shellquote=
  set shellxquote=
endif

let mapleader = ""

" --------------------- Plugin Configs ----------------------
lua << EOF

require("bufferline").setup {
  options = {
    mode = "tabs", -- hoặc "buffers"
    separator_style = "slant", -- | "thick" | "thin" | "slant" | "padded_slant"
    show_close_icon = false,
    show_buffer_close_icons = false,
    diagnostics = "nvim_lsp",
  }
}

require("nvim-autopairs").setup({
  check_ts = true,
  fast_wrap = {},
  enable_check_bracket_line = false,
  map_cr = true,  -- bật Enter auto insert,
})

require('lualine').setup {
  options = {
    theme = 'auto',
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  }
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}


require("nvim-tree").setup({
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    -- Mặc định các phím gán sẵn
    api.config.mappings.default_on_attach(bufnr)

    local function opts(desc)
      return {
        desc = "nvim-tree: " .. desc,
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      }
    end
    vim.keymap.set('n', 't', function()
  local node = require("nvim-tree.api").tree.get_node_under_cursor()
  if node and node.type == "file" then
    vim.cmd("tabnew " .. node.absolute_path)
  end
end, opts("Open File in New Tab"))


    vim.keymap.set('n', '<BS>', api.tree.change_root_to_parent, opts("Up to Parent Directory"))
    -- Gán phím C: nếu đang chọn là file thì cd vào folder chứa nó
    vim.keymap.set('n', 'C', function()
      local node = api.tree.get_node_under_cursor()
      if not node then return end

      if node.type == "file" then
        api.tree.change_root(node.parent.absolute_path)
      elseif node.type == "directory" then
        api.tree.change_root(node.absolute_path)
      end
    end, opts("Change Root to Node or Node's Parent"))
  end
})




require('alpha').setup(require('alpha.themes.dashboard').config)
require('telescope').load_extension('frecency')
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        preview_width = 0.5,
        results_width = 0.5,
      },
      prompt_position = "top",
      preview_cutoff = 1,
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<C-d>"] = actions.delete_buffer,
      },
      n = {
        ["<C-d>"] = actions.delete_buffer,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      previewer = true,
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["<C-d>"] = actions.delete_buffer,
        },
      },
    },
  },
})

require("ibl").setup {
  indent = {
    char = "│", -- hoặc dùng "▏", "¦" tùy thích
  },
  scope = {
    enabled = true,
  },
}


EOF

" Quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg=#eb4034 gui=bold ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg=#00fff7 gui=bold ctermfg=81 cterm=underline


" Supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

" Flake8
let g:flake8_show_in_file = 1

" Copilot config
let g:copilot_enabled = 0
function! ToggleCopilot()
  if exists('*copilot#Enabled') && copilot#Enabled()
    Copilot disable
    echo "🤖 Copilot đã tắt"
  else
    Copilot enable
    echo "🤖 Copilot đã bật"
  endif
endfunction
nnoremap <leader>a :call ToggleCopilot()<CR>


" Tree-sitter folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldenable
set foldlevelstart=99

" Strip trailing whitespace
function! StripTrailingWhitespace()
  if exists('b:noStripWhitespace')
    return
  endif
  %s/\s\+$//e
endfunction

autocmd BufWritePre * call StripTrailingWhitespace()
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd FileType markdown let b:noStripWhitespace=1
highlight ExtraWhitespace ctermbg=NONE guibg=#1B1D1E
match ExtraWhitespace /\s\+$/

" Highlight tweaks
highlight Comment gui=italic guifg=#5c6370
highlight Constant guifg=#d19a66
highlight Identifier guifg=#61afef
highlight Statement guifg=#c678dd
highlight PreProc guifg=#e5c07b
highlight Type guifg=#56b6c2
highlight Special guifg=#c678dd
highlight Underlined guifg=#61afef gui=underline
highlight Todo guifg=#ff0000 guibg=#ffff00 gui=bold
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE

" ========================= Key mappings ==========================
nnoremap <leader>ff :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg :lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fh :lua require('telescope.builtin').oldfiles()<CR>
nnoremap <leader>fr :lua require('telescope').extensions.frecency.frecency()<CR>
nnoremap <leader>fm :lua require('telescope.builtin').marks()<CR>
nnoremap <leader>e :CocList diagnostics<CR>
nnoremap <leader>b :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>d :silent! %bd\|e#<CR>
nnoremap <leader>h :Alpha<CR>
nnoremap <leader>n :set relativenumber!<CR>
nnoremap <leader>s :source $MYVIMRC<CR>
nnoremap <space>e :NvimTreeToggle<CR>
noremap <space>f :NvimTreeFindFile<CR>
noremap <space>pv :vs\|:Ex<CR>
nnoremap <space>z za
nnoremap <space>o zO
nnoremap <space>c zC
nnoremap <space>O zR
nnoremap <space>C zM
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>

" Format code
nnoremap <C-f> :call CocAction('format')<CR>
inoremap <C-f> <Esc>:call CocAction('format')<CR>a

" Code navigation
nnoremap gd :call <SID>GoToDefinition()<CR>
function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif
  let ret = execute("silent! normal <C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

" Clipboard and editing
nnoremap <C-v> "+gP
cnoremap <C-v> <C-r>+
inoremap <C-v> <esc>"+gP
vnoremap <C-v> "+gP
vnoremap <C-c> "+y
vnoremap <C-x> "+x
inoremap <C-j> <Esc>o
inoremap <C-k> <Esc>O
inoremap <C-d> <Esc>ddi
inoremap <C-l> <C-o>$
inoremap <C-a> <C-o>0
nnoremap <C-a> ggVG
nnoremap <C-z> u
inoremap <C-z> <C-o>u
nnoremap <C-y> <C-r>
inoremap <C-y> <C-o><C-r>
inoremap <Esc> <Esc>:w<CR>




" Hover docs
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
hi! link CocHighlightText CursorColumn

" ===================== Compile / Run ======================
" C/C++
nnoremap <F6> :!gcc -o %:r %:t<CR>
nnoremap <F7> :!g++ -std=c++14 -o %:r %:t<CR>
nnoremap <F8> :!%:r<CR>
autocmd FileType cpp nnoremap <buffer> <F5> :w<CR>:!g++ -std=c++14 -o %:r %:p && %:r.exe<CR>

" Java
nnoremap <F3> :!javac %:t<CR>
nnoremap <F4> :!java %:r<CR>

" Python
nnoremap <F1> :term python %:t<CR>

" JavaScript
autocmd FileType javascript nnoremap <F2> :w<CR>:!node %<CR>

" Terminal
tnoremap <Esc> <C-\><C-n>
autocmd InsertEnter * :nohlsearch
lua << EOF
-- Toggle floating‑terminal với <A‑t> ở mọi chế độ
local term = {
  bufnr  = nil,  -- buffer chạy job terminal
  winid  = nil,  -- floating window
  prev_win = nil,
  prev_insert = false, -- true nếu bật terminal khi đang insert
}

local function toggle_terminal()
  -- Nếu terminal đang mở → đóng & trả focus
  if term.winid and vim.api.nvim_win_is_valid(term.winid) then
    vim.api.nvim_win_close(term.winid, true)
    term.winid = nil

    if term.prev_win and vim.api.nvim_win_is_valid(term.prev_win) then
      vim.api.nvim_set_current_win(term.prev_win)
      if term.prev_insert then
        vim.cmd("startinsert")            -- trở lại insert nếu trước đó đang insert
      end
    end
    return
  end

  -- Lưu cửa sổ & trạng thái insert hiện tại
  term.prev_win    = vim.api.nvim_get_current_win()
  term.prev_insert = vim.api.nvim_get_mode().mode:sub(1,1) == "i"

  -- Tạo buffer nếu chưa có
  if not (term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr)) then
    term.bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(term.bufnr, "bufhidden", "hide")
  end

  -- Tính toán kích thước/đặt vị trí floating
  local width  = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines   * 0.6)
  term.winid = vim.api.nvim_open_win(term.bufnr, true, {
    relative = "editor",
    row    = math.floor((vim.o.lines   - height) / 2),
    col    = math.floor((vim.o.columns - width)  / 2),
    width  = width,
    height = height,
    style  = "minimal",
    border = "rounded",
  })

  -- Khởi tạo job terminal một lần duy nhất
  if vim.b[term.bufnr].terminal_job_id == nil then
    vim.fn.termopen(vim.o.shell)
  end

  vim.cmd("startinsert") -- sẵn sàng gõ lệnh trong terminal
end

-- Map cho cả normal, insert, terminal
vim.keymap.set({ "n", "i", "t" }, "<A-a>", toggle_terminal, { noremap = true, silent = true })

EOF

" Tự động lưu file nếu có thay đổi khi dùng :q hoặc chuyển buffer
autocmd FocusLost,BufLeave,WinLeave * if &modified | silent! write | endif

" Confirm Coc selection
" --- CoC + xuống dòng có indent ---
inoremap <silent><expr> <CR> pumvisible()
      \ ? coc#pum#confirm()
      \ : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"



" Done – có thể copy nguyên file dùng luôn!
