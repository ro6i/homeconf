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

nmap <silent> <Tab> :call search('\u', 'W', line("."))<CR>
nmap <silent> <Backspace> :call search('\u', 'bW', line("."))<CR>

nnoremap <silent> !c :set cursorline!<CR>
nnoremap <silent><expr> !h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
nnoremap <silent> !lc :setlocal cursorbind!<CR>:call lightline#update()<CR>
nnoremap <silent> !ls :setlocal scrollbind!<CR>:call lightline#update()<CR>
nnoremap <silent> !r :set list!<CR>
nnoremap <silent> !w :set wrap!<CR>
nnoremap <silent> !z :let &scrolloff=999-&scrolloff<CR>

nnoremap <silent> !\ :call ToggleColorColumn(80)<CR>
nnoremap <silent> ![ :call ToggleColorColumn(120)<CR>
nnoremap <silent> !] :call ToggleColorColumn(160)<CR>

xmap     <silent> <Leader>a <Plug>(EasyAlign)
vnoremap <silent> <Leader>c "*y
nnoremap <silent> <Leader>f :call FindTextPrompt()<CR>
vnoremap <silent> <Leader>f y:FindTextExact <C-R>"<CR>
nnoremap <silent> <Leader>l :call NextKeymap()<CR>:call lightline#update()<CR>
nnoremap <silent> <Leader>rr :tabnew<CR>:term<CR>iranger<CR>
nnoremap <silent> <Leader>v "*p
vnoremap <silent> <Leader>v "*p
nnoremap <silent> <Leader>x :Vexplore<CR>
nnoremap          <Leader>sh :w !bash<CR>

nnoremap <silent> <Leader><Leader> :Files<CR>

nnoremap <silent> <Space> <nop>
nnoremap <silent> <Space><Space> za
nnoremap <silent> <Space>1 1gt<CR>
nnoremap <silent> <Space>2 2gt<CR>
nnoremap <silent> <Space>3 3gt<CR>
nnoremap <silent> <Space>4 4gt<CR>
nnoremap <silent> <Space>5 5gt<CR>
nnoremap <silent> <Space>6 6gt<CR>
nnoremap <silent> <Space>7 7gt<CR>
nnoremap <silent> <Space>8 8gt<CR>
nnoremap <silent> <Space>9 9gt<CR>
nnoremap <silent> <Space>l :GotoLastTab<CR>
nnoremap <silent> <Space>n :tabnext<CR>
nnoremap <silent> <Space>p :tabprevious<CR>
nnoremap <silent> <Space>t :tabnew<CR>
nnoremap <silent> <Space>q :copen<CR>
nnoremap <silent> <Space>x :q<CR>
nnoremap <silent> <Space>X :q!<CR>
nnoremap <silent> <Space>z :qa<CR>
nnoremap <silent> <Space>Z :qa!<CR>

vnoremap <silent> <M-c> "*y
inoremap <silent> <M-v> <C-o>"*p
nnoremap <silent> <M-v> "*p
vnoremap <silent> <M-v> "*p
inoremap <silent> <M-l> <C-o>:call NextKeymap()<CR><C-o>:call lightline#update()<CR>
nnoremap <silent> <M-l> :call NextKeymap()<CR>:call lightline#update()<CR>

vnoremap r "_dP
vnoremap * y/\V<C-R>"<CR>

tnoremap <C-\><C-\> <C-\><C-n>
tnoremap <silent> <C-\><C-]> <C-\><C-n>:GotoLastTab<CR>

call plug#begin()

let g:plug_url_format = "https://git::@github.com/%s.git"
Plug 'itchyny/lightline.vim'
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
Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/bufkill.vim'
Plug 'vim-scripts/BufOnly.vim'
" Plug 'vim-scripts/AnsiEsc.vim'
Plug 'kshenoy/vim-signature'
Plug 'rhysd/open-pdf.vim'
" Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeEnable' }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
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

function! LightlineKeymap()
  return !exists("b:keymap_name") ? "" : toupper(b:keymap_name)
endfunction
function! LightlineBindings()
  let value = (&cursorbind ? "C" : "") . (&scrollbind ? "S" : "")
  return (&cursorbind || &scrollbind) ? ('● ' . value) : ''
endfunction
let g:lightline = { 'colorscheme': 'm31', 'lineinfo': "%{line('.') . ':' . col('.') . '/' . line('$')}", 'filename': "%f", 'tabline': { 'left': [ [ 'tabs' ] ], 'right': [ ] }, 'mode_map': { 'n' : ' N ', 'i' : ' I ', 'R' : ' R ', 'v' : ' V ', 'V' : 'V-L', "\<C-v>": 'V-B', 'c' : ' C ', 's' : ' S ', 'S' : 'S-L', "\<C-s>": 'S-B', 't': ' T ' }, 'component_expand': { 'keymap': 'LightlineKeymap', 'scrollbind': 'LightlineScrollbind', 'bindings': 'LightlineBindings'}, 'component_type': { 'keymap': 'warning', 'bindings': 'warning' }, 'active': { 'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ], ['keymap', 'bindings' ] ] }, 'subseparator': { 'left': '', 'right': '|' } }

let g:snugfind_exclude_dir = 'project,target,build,.git,.idea,.build,.ensime_cache,node_modules,tmp,log'
let g:snugfind_exclude = '.tags,.ensime'

let g:python_highlight_all = 1

if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore={.git,.svn,build,project,target,build,__pycache__} -g ""'
endif
let g:fzf_colors = { 'fg': ['fg', 'Normal'], 'bg': ['bg', 'Normal'], 'hl': ['fg', 'Comment'], 'fg+': ['fg', 'Normal', 'Comment', 'Normal'], 'bg+': ['bg', 'Normal', 'Normal'], 'hl+': ['fg', 'Statement'], 'info': ['fg', 'PreProc'], 'border': ['fg', 'Ignore'], 'prompt': ['fg', 'Conditional'], 'pointer': ['fg', 'Exception'], 'marker':  ['fg', 'Keyword'], 'spinner': ['fg', 'Label'], 'header':  ['fg', 'Comment'] }

function! ToggleColorColumn(width)
  execute "setlocal colorcolumn=" . (&colorcolumn == a:width ? 0 : a:width)
endfunction

function! NextKeymap()
  if empty(&keymap)
    setlocal keymap=russian-yasherty
  else
    setlocal keymap=
  endif
endfunction

command! Conf source $MYVIMRC
command! RemoveTrailingWhitespace %s/\s\+$//e
command! CopyPathAbs let @+ = expand('%:p') | echo '"'.@+.'"' "copied to @+"
command! CopyPathRel let @+ = fnamemodify(expand("%"), ":~:.") | echo '"'.@+.'"' "copied to @+"
command! CopyDirAbs let @+ = expand("%:h") | echo '"'.@+.'"' "copied to @+"
command! CopyDirRel let @+ = expand("%:h") | echo '"'.@+.'"' "copied to @+"
command! FormatJSON %!python -m json.tool
command! AsJSON set syntax=json | FormatJSON

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
hi link GitGutterAdd LineNr
hi link GitGutterChange LineNr
hi link GitGutterDelete LineNr
hi link GitGutterChangeDelete LineNr
hi! def link Define Keyword
hi! def link rubyIdentifier NONE
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
