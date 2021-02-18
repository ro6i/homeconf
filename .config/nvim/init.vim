nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
nnoremap <C-l> 5zl
nnoremap <C-h> 5zh

nnoremap <silent> qf :copen<CR>

nmap <silent> <Tab> :call search('\u', 'W', line("."))<CR>
nmap <silent> <Backspace> :call search('\u', 'bW', line("."))<CR>

xmap     <silent> <Leader>a <Plug>(EasyAlign)
nnoremap <silent> <Leader>f :call FindTextSettings()<CR>
nnoremap <silent> <Leader>s :call FindTextPrompt()<CR>
vnoremap <silent> <Leader>s y:FindTextExact <C-R>"<CR>
nnoremap <silent> <Leader>g :Gblame<CR>
nnoremap <silent> <Leader>l <C-o>:call NextKeymap()<CR><C-o>:call lightline#update()<CR>
nnoremap <silent> <Leader>p "*p
vnoremap <silent> <Leader>p "*p
nnoremap <silent> <Leader>P "*P
vnoremap <silent> <Leader>P "*P
inoremap <silent> <M-v>      <C-o>"*p
nnoremap <silent> <Leader>r :Ranger<CR>
nnoremap <silent> <Leader>rr :tabnew<CR>:term<CR>iranger<CR>
nnoremap <silent> <Leader>t :call SetNvimPipe('NVIM_PIPE')<CR>
vnoremap <silent> <Leader>y "*y

vnoremap          <Leader>np :w !tmux-pipe-to-next-pane<CR>
nnoremap          <Leader>ex :w !bash<CR>

nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <Leader><Bar> :Buffers<CR>

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

nnoremap <silent> <Space>a <C-w>w<C-w><Bar>z999<CR>
nnoremap <silent> <Space>b :b#<CR>
nnoremap <silent> <Space>d :bd<CR>
nnoremap <silent> <Space>f :call ToggleQuickfixList()<CR>
nnoremap <silent><expr> <Space>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
nnoremap <silent> <Space>j *
nnoremap <silent> <Space>l :GotoLastTab<CR>
nnoremap <silent> <Space>n :tabnext<CR>

nnoremap <silent> <Space>rj :resize -5<CR>
nnoremap <silent> <Space>rk :resize +5<CR>
nnoremap <silent> <Space>rh :vertical resize -5<CR>
nnoremap <silent> <Space>rl :vertical resize +5<CR>

nnoremap <silent> <Space>p :tabprevious<CR>
nnoremap <silent> <Space>t :tabnew<CR>

nnoremap <silent> <Space>wh <C-w>h
nnoremap <silent> <Space>wj <C-w>j
nnoremap <silent> <Space>wk <C-w>k
nnoremap <silent> <Space>wl <C-w>l

nnoremap <silent> <Space><Space>w :set wrap!<CR>
nnoremap <silent> <Space><Space>c :set cursorline!<CR>
nnoremap <silent> <Space><Space>lc :setlocal cursorbind!<CR>:call lightline#update()<CR>
nnoremap <silent> <Space><Space>ls :setlocal scrollbind!<CR>:call lightline#update()<CR>
nnoremap <silent> <Space><Space>r :set list!<CR>
nnoremap <silent> <Space><Space>z :let &scrolloff=999-&scrolloff<CR>
nnoremap <silent> <Space>\ :call ToggleColorColumn(80)<CR>
nnoremap <silent> <Space>[ :call ToggleColorColumn(120)<CR>
nnoremap <silent> <Space>] :call ToggleColorColumn(160)<CR>

nnoremap <silent> <Space>x :Vexplore<CR>
nnoremap <silent> <Space>q :q<CR>
nnoremap <silent> <Space>z :call ToggleWindowSize()<CR>

" fuzzy go-to definition
nnoremap <silent> <Space>s<Space> viw"ty:call FindTextFlat(getreg('t'))<CR>
nnoremap <silent> <Space>sj viw"ty:call FindTextRegex('(class\\|object\\|trait\\|def\\|val\\|function\\|fun\\|fn\\|const\\|auto)\s+' . getreg('t') . '\s*[^\w]')<CR>:nohls<CR>
nnoremap <silent> <Space>so viw"ty:call FindTextRegex('(class\\|object\\|trait\\|def\\|val\\|function\\|fun\\|fn\\|const\\|auto)\s+' . getreg('t') . '\s*[^\w]')<CR><C-w><Enter><C-w>T:nohls<CR>
" fuzzy show usages
nnoremap <silent> <Space>su viw"ty:call FindTextRegex('((with\s\\|extends\s\\|[\(\[])' . getreg('t') . '\\|(?<!def\s\\|val\s\\|ass\s\\|ect\s)' . getreg('t') . '[\)(\[\} ])')<CR>:nohls<CR>

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
Plug 'milkypostman/vim-togglelist'
" Plug 'vim-scripts/AnsiEsc.vim'
Plug 'kshenoy/vim-signature'
Plug 'rhysd/open-pdf.vim'
" Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeEnable' }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'francoiscabrol/ranger.vim'
" Plug 'inkarkat/vim-SyntaxRange'
Plug 'haya14busa/incsearch.vim'
Plug 'ro6i/m31.vim'
Plug 'ro6i/snugfind.vim'
Plug 'ro6i/gotolasttab.vim'
Plug 'ro6i/maximize-toggle.vim'
Plug 'ro6i/env-vars.vim'
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

let g:ranger_map_keys = 0

let g:env_variables = {}

function! LightlineKeymap()
  return !exists("b:keymap_name") ? "" : toupper(b:keymap_name)
endfunction
function! LightlineBindings()
  let value = (&cursorbind ? "C" : "") . (&scrollbind ? "S" : "")
  return (&cursorbind || &scrollbind) ? ('● ' . value) : ''
endfunction
function! LightlineSnugfind()
  return GetFindSettingsSettings() . " |"
endfunction

function! LightlineLineinfo()
  "%3p%%
  return "%12{line('.') . ':' . col('.') . ' /' . line('$')}"
endfunction
let g:lightline = { 'colorscheme': 'm31', 'filename': "%f", 'tabline': { 'left': [ [ 'tabs' ] ], 'right': [ ] }, 'mode_map': { 'n' : 'N', 'i' : 'I', 'R' : 'R', 'v' : 'V', 'V' : 'L', "\<C-v>": 'B', 'c' : 'C', 's' : 'S', 'S' : 'S-L', "\<C-s>": 'S-B', 't': 'T' }, 'component_expand': { 'keymap': 'LightlineKeymap', 'env': 'LightlineEnv', 'snugfind': 'LightlineSnugfind', 'bindings': 'LightlineBindings', 'lineinfo': 'LightlineLineinfo' }, 'component_type': { 'keymap': 'warning', 'bindings': 'warning' }, 'active': { 'right': [ [], [ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype' ], ['keymap', 'bindings', 'env', 'snugfind' ] ] }, 'inactive': { 'right': [ [ 'lineinfo' ] ] }, 'subseparator': { 'left': '', 'right': '|' } }

let g:snugfind_exclude_dirs = 'project,target,build,.git,.idea,.build,.ensime_cache,node_modules,tmp,log,frontend/tmp,__'
let g:snugfind_exclude_files = '.tags,.ensime'

let g:python_highlight_all = 1

if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --follow --ignore={tmp,frontend/tmp,.git,.svn,build,project,target,build,__pycache__,__} -g ""'
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

command! Pipe :w !tmux-pipe-to-next-pane

set nowrap
set noshowmode
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start

" set list
set listchars=tab:>-,trail:.,extends:>,precedes:<,eol:¬

"set fillchars+=vert:

set hlsearch
set incsearch
set ignorecase
set smartcase

" until neovim has cursorlineopt merged
set nocursorline
if !has('nvim')
  set cursorline
  set cursorlineopt=number
endif
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
hi scalaSquareBracketsBrackets ctermfg=15
hi! link scalaKeywordModifier StorageClass
" au BufRead,BufNewFile * syn match parensCustomLeft /[(]/ | hi parensCustomLeft ctermfg=6
au BufRead,BufNewFile * syn match parensCustomLeft /[(]/ | hi parensCustomLeft ctermfg=15
au BufRead,BufNewFile * syn match parensCustomRight /[)]/ | hi parensCustomRight ctermfg=13

function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

au FileType md,latex,tex,md,markdown setlocal spell
au FileType qf nnoremap <buffer> <Space><Enter> <C-w><Enter><C-w>T
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType yaml hi link yamlKey Label
