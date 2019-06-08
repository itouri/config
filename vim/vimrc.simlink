set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" 導入したいプラグインを以下に列挙
" Plugin '[Github Author]/[Github repo]' の形式で記入
Plugin 'airblade/vim-gitgutter'
Plugin 'fatih/vim-go'

Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'

" powerline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" nerdtree
Plugin 'scrooloose/nerdtree'
map <C-e> :NERDTreeToggle<CR>

" golsp の設定
let g:lsp_diagnostics_enabled = 0
" debug
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')
let g:asyncomplete_log_file = expand('~/asyncomplete.log')

if executable('gopls')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'gopls',
	        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
	        \ 'whitelist': ['go'],
	        \ })
endif

call vundle#end()
filetype plugin indent on
