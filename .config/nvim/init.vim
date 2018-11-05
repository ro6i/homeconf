nnoremap gn gt
nnoremap gr gT

nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
nnoremap <C-l> 5zl
nnoremap <C-h> 5zh
nnoremap <C-x> $x
nmap <C-w>a <C-w>w<C-w><Bar>0
nmap <C-w><Leader> <C-w><Bar>

nnoremap <silent> co :copen<CR>
nnoremap <silent> gb :b#<CR>
nnoremap <silent> gl :GotoLastTab<CR>

nnoremap <silent> !w :set wrap!<CR>
nnoremap <silent> !l :set list!<CR>
nnoremap <silent> !z :let &scrolloff=999-&scrolloff<CR>

nmap <silent> <Tab> :call search('\u', 'W', line("."))<CR>
nmap <silent> <Backspace> :call search('\u', 'bW', line("."))<CR>

nnoremap <silent> !\ :call ToggleColorColumn(80)<CR>
nnoremap <silent> ![ :call ToggleColorColumn(120)<CR>
nnoremap <silent> !] :call ToggleColorColumn(160)<CR>

nnoremap <silent> !s :set scb!<CR>:call lightline#update()<CR>
nnoremap <silent> !zz :let &scrolloff=999-&scrolloff<CR>
nnoremap <silent><expr> !h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

nnoremap <silent> <Leader>t :tabnew<CR>
nnoremap <silent> <Leader>f :call FindTextPrompt()<CR>
nnoremap <silent> <Leader>rr :tabnew<CR>:term<CR>iranger<CR>
nnoremap <silent> <Leader>x :Vexplore<CR>
nnoremap <Leader>sh :w !bash<CR>

nnoremap <silent> <C-p> :CtrlP<CR>
nnoremap <silent> <C-P> :CtrlPLine<CR>

vnoremap r "_dP
vnoremap * y/\V<C-R>"<CR>
vnoremap <silent> \\ y:FindTextExact <C-R>"<CR>

inoremap <silent> <F6> <C-o>:call NextKeymap()<CR><C-o>:call lightline#update()<CR>
nnoremap <silent> <F6> :call NextKeymap()<CR>:call lightline#update()<CR>

vnoremap <silent> <F8> "*y
nnoremap <silent> <F9> "*p
inoremap <silent> <F9> <C-o>"*p

tnoremap <C-\><C-\> <C-\><C-n>
tnoremap <silent> <C-\><C-]> <C-\><C-n>:GotoLastTab<CR>

call plug#begin()

let g:plug_url_format = "https://git::@github.com/%s.git"
Plug 'itchyny/lightline.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'derekwyatt/vim-scala'
Plug 'GEverding/vim-hocon'
Plug 'neovimhaskell/haskell-vim'
Plug 'bitc/vim-hdevtools'
Plug 'hdima/python-syntax'
Plug 'chrisbra/csv.vim'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/bufkill.vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'kshenoy/vim-signature'
Plug 'rhysd/open-pdf.vim'
" Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeEnable' }
Plug 'ro6i/m31.vim'
Plug 'ro6i/snugfind.vim'
Plug 'ro6i/gotolasttab.vim'
Plug 'ro6i/russian-yasherty.vim'

let g:plug_url_format = "https://git::@gitlab.com/%s.git"

call plug#end()

syntax on
colorscheme m31


let g:java_highlight_all = 1

let g:gitgutter_map_keys = 0

let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_sort_options = 'i'
let g:netrw_keepdir = 1
let g:netrw_winsize = 20

let g:ctrlp_custom_ignore = {
\ 'dir':  '\.git$\|\.svn$\|\.build$\|project$\|target$\|build$\|__pycache__$',
\ 'file': '\.exe$\|\.so$\|\.dat$'
\}
let g:ctrlp_root_markers = ['pom.xml', 'project', '.git', '.svn', '.idea']
let g:ctrlp_working_path_mode = 0
let g:ctrlp_mruf_save_on_update = 0
let g:ctrlp_mruf_relative = 0
let g:ctrlp_max_files = 0
let g:ctrlp_match_window = 'min:4,max:20'

function! LightlineKeymap()
  return !exists("b:keymap_name") ? "" : toupper(b:keymap_name)
endfunction
function! LightlineScrollbind()
  return &scrollbind ? "SB" : ""
endfunction
let g:lightline = { 'colorscheme': 'm31', 'lineinfo': "%{line('.') . ':' . col('.') . '/' . line('$')}", 'filename': "%f", 'tabline': { 'left': [ [ 'tabs' ] ], 'right': [ ] }, 'mode_map': { 'n' : ' N ', 'i' : ' I ', 'R' : ' R ', 'v' : ' V ', 'V' : 'V-L', "\<C-v>": 'V-B', 'c' : ' C ', 's' : ' S ', 'S' : 'S-L', "\<C-s>": 'S-B', 't': ' T ' }, 'component_expand': { 'keymap': 'LightlineKeymap', 'scrollbind': 'LightlineScrollbind'}, 'component_type': { 'keymap': 'warning', 'scrollbind': 'info' }, 'active': { 'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ], ['keymap', 'scrollbind'] ] }, 'subseparator': { 'left': '', 'right': '|' } }

let g:snugfind_exclude_dir = 'project,target,build,.git,.idea,.build,.ensime_cache'
let g:snugfind_exclude = '.tags,.ensime'

let g:python_highlight_all = 1

" open tag in a split
" nnoremap <C-]> :sp <CR>:exec("tag ".expand("<cword>"))<CR>
" nnoremap <C-_> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

function! ToggleColorColumn(width)
  if &colorcolumn == a:width
    setlocal colorcolumn=0
  else
    execute "setlocal colorcolumn=" . a:width
  endif
endfunction

function! NextKeymap()
  if empty(&keymap)
    setlocal keymap=russian-yasherty
  else
    setlocal keymap=
  endif
endfunction

command! RemoveTrailingWhitespace %s/\s\+$//e
command! CopyFilePathAbs let @+ = expand('%:p')
command! CopyFilePathRel let @+ = expand('%')
command! FormatJSON %!python -m json.tool
command! AsJSON set syntax=json | FormatJSON
command! Es w !bash

set nowrap
set noshowmode
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start

"set list
set listchars=tab:>-,trail:.,extends:>,precedes:<,eol:¬

"set fillchars+=vert:

set hlsearch
set incsearch
set ignorecase
set smartcase

set nocursorline
set nocursorcolumn
set showmatch
set number
set numberwidth=4
set linespace=1
set splitbelow
set splitright
set autoread
set foldmethod=indent
set foldlevel=1
set colorcolumn=0
set conceallevel=1
set scrollopt+=hor

set spelllang=en,ru_yo

set tags=./.tags,.tags,./tags,tags

au TermOpen * setlocal nonumber norelativenumber

" colors
hi SignatureMarkText ctermfg=10
hi SignatureMarkLine ctermbg=0
hi scalaSquareBracketsBrackets ctermfg=9
au BufRead,BufNewFile * syn match parensRoundLeft /[(]/ | hi parensRoundLeft ctermfg=6
au BufRead,BufNewFile * syn match parensRoundRight /[)]/ | hi parensRoundRight ctermfg=13
au BufRead,BufNewFile * syn match parensCurly /[{}]/ | hi parensCurly ctermfg=10

function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" au InsertEnter,InsertLeave * silent redraw!

au FileType md,latex,tex,md,markdown,scala,java,sbt setlocal spell
au FileType qf nnoremap <buffer> g<Enter> <C-w><Enter><C-w>T
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
