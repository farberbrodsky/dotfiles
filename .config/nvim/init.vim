call plug#begin('~/.config/nvim/plugged')

" CODE COMPLETION

Plug 'neoclide/coc.nvim', {'branch': 'release'}

let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-snippets',
    \ 'coc-tsserver',
    \ 'coc-rls',
    \ 'coc-python',
    \ 'coc-eslint',
    \ 'coc-pairs'
\ ]

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    call CocAction('doHover')
    " move to the preview window, make it on the right, then go back to
    " current window
    wincmd P
    wincmd L
    wincmd p
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming
nmap <leader>r <Plug>(coc-rename)

" Shorter updatetime
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Code snippets expansion with Ctrl+L
imap <C-l> <Plug>(coc-snippets-expand)


" FUNCTIONALITY

" Fugitive, git with :Git
Plug 'tpope/vim-fugitive'

" Features for preview window for documentation opened with K
Plug 'skywind3000/vim-preview'
noremap <m-j> :PreviewScroll +1<cr>
noremap <m-k> :PreviewScroll -1<cr>

" Indentation detection with :DetectIndent
Plug 'roryokane/detectindent'
let g:detectindent_preferred_indent = 2
augroup DetectIndent
   autocmd!
   autocmd BufReadPost *  DetectIndent
augroup END

" The tree file viewer sidebar
Plug 'scrooloose/nerdtree'
" close nerdtree if it's the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

Plug 'easymotion/vim-easymotion'
nmap <Space> <Plug>(easymotion-overwin-w)
Plug 'chrisbra/colorizer'
let g:rainbow_conf = {
\    'guifgs': ['#ff5555', '#ffb86c', '#f1fa8c', '#50fa7b', '#8be9fd']
\}

" Ctrl-P for fuzzy file search
Plug 'ctrlpvim/ctrlp.vim'
nnoremap <C-o> :CtrlPClearAllCaches<CR>:CtrlP<CR>
set wildignore+=*/target/*,*/node_modules/*,*.so,*.swp,*.zip
" A super cool plugin, it's like an interactive python/nodejs session but it shows
" output on every line and you can change stuff in retrospective. Activate for
" a file with :Codi
Plug 'metakirby5/codi.vim'

" A plug that saves sessions automatically with :Obsess, so that my vim stays
" as it was, even after I close it.
" Remember to do vim -S Session.vim later
Plug 'tpope/vim-obsession'

" Vim + Tmux navigation
Plug 'christoomey/vim-tmux-navigator'

" LOOK AND FEEL

" Color scheme
Plug 'dracula/vim', { 'as': 'dracula' }
" Status line
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline_section_z = ' %{strftime("%-I:%M %p")}' " Show time instead of line number
" Indentation line
Plug 'yggdroot/indentline'
" Icons for NERDTree and airline
Plug 'ryanoasis/vim-devicons'


" OTHER FEATURES

" Rainbow parentheses
Plug 'luochen1990/rainbow'

call plug#end()

" I have colors in my terminal.
set termguicolors
" Dracula is the best.
colorscheme dracula


" AUTOCMD
" Automatically turn on rainbow parentheses when opening a new file, this
" doesn not include nerd tree.
autocmd BufNewFile * :RainbowToggleOn
autocmd BufRead    * :RainbowToggleOn

" KEYBINDINGS
" Leave terminal without a weird key combination
tmap <Esc> <C-\><C-n>

" Control+f for NERDTree
nnoremap <C-f> :NERDTreeToggle<Enter>

" Copy and paste
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
nmap <C-v> "+p
imap <C-v> <ESC>"+pa

" Use jk,kj to Escape from insert mode
imap jk <Esc>
imap kj <Esc>
vmap jk <Esc>
vmap kj <Esc>

" C-h,j,k,l to move between windows (save a keystroke)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" VIM SETTINGS
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set number
set relativenumber
set timeoutlen=100

" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR>
