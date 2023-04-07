set nocompatible              " be iMproved, required
filetype off                  " required
syntax on
set background=dark

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"set rtp+=~/.vim/bundle/nerdtree
call plug#begin()
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Raimondi/delimitMate'
Plug 'fatih/vim-go'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tomasr/molokai'
Plug 'dracula/vim'
Plug 'morhetz/gruvbox'
Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'
Plug 'github/copilot.vim'
call plug#end()

if exists("g:did_load_filetypes")
  filetype off
  filetype plugin indent off
endif
set runtimepath+=$GOROOT/misc/vim 
filetype plugin indent on
syntax on

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

nnoremap <leader>a :cclose<CR>
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
let g:go_diagnostics_level = 2
let g:rustfmt_autosave = 1
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
set completeopt-=preview

colorscheme dracula
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
filetype plugin indent on

