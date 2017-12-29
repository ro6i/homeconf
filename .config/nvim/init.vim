nnoremap <C-j> 5<C-e>
nnoremap <C-k> 5<C-y>
nnoremap <C-l> 5zl
nnoremap <C-h> 5zh

nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap <Down> gj
vnoremap <Up>   gk
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk

nnoremap <Enter> ;
vnoremap <Enter> ;

xmap     <silent> <Leader>a         <Plug>(EasyAlign)
nnoremap <silent> <Leader>b         :s/\\n\\t/\r/g<CR>
vnoremap <silent> <Leader>c         y:OSCYankVisual<CR>
nmap     <silent> <Leader>cp        :let @+ = @%<CR>
nnoremap <silent> <Leader>d         :windo diffthis<CR>
nnoremap <silent> <Leader>g         :tab split<CR>:Gvdiffsplit<CR>
nnoremap <silent> <Leader>gd        :tab split<CR>:Gvdiffsplit develop<CR>
nnoremap <silent> <Leader>gb        :Git blame<CR>
nnoremap <silent> <Leader>f         :call FindTextSettings()<CR>
nnoremap <silent> <Leader>hc        /=======<CR>
nnoremap <silent> <Leader>j         :AsJSON<CR>
nnoremap <silent> <Leader>jj        :AsJSON<CR>
nnoremap <silent> <Leader>jl        :%s/\\n/\r/g<CR>:%s/\\t/  /g<CR>
nnoremap <silent> <Leader>s         :call FindTextPrompt()<CR>
nnoremap <silent> <Leader>l         :call NextKeymap()<CR>:call lightline#update()<CR>
nnoremap <silent> <Leader>wp        "+p
vnoremap <silent> <Leader>wp        "+p
nnoremap <silent> <Leader>wP        "+P
vnoremap <silent> <Leader>wP        "+P
vnoremap <silent> <Leader>wy        "+y
inoremap <silent> <M-v>             <C-o>"+p
nnoremap <silent> <Leader>r         :Ranger<CR>
nnoremap <silent> <Leader>rr        :tabnew<CR>:term<CR>iranger<CR>
nnoremap <silent> <Leader>rw        :RangerWorkingDirectory<CR>
nnoremap <silent> <Leader>rt        :RangerCurrentFileNewTab<CR>
nnoremap <silent> <Leader>t         :call SetNvimPipe('NVIM_PIPE')<CR>
vnoremap <silent> <Leader>y         y<cr>:call system("tmux load-buffer -", @0)<cr>
nnoremap          <Leader>p         :let @0 = system("tmux save-buffer -")<cr>"0p<cr>g;

vnoremap          <Leader>np        :w !tmux-pipe-to-next-pane<CR>
nnoremap          <Leader>ex        :w !bash<CR>

nnoremap <silent> <Leader><Leader>  :Files<CR><C-_>
nnoremap <silent> <Leader><Bar>     :Buffers<CR>

nnoremap <silent> <Space>           <nop>
nnoremap <silent> <Space><Enter>    :w<CR>
nnoremap <silent> <Space>1          1gt<CR>
nnoremap <silent> <Space>2          2gt<CR>
nnoremap <silent> <Space>3          3gt<CR>
nnoremap <silent> <Space>4          4gt<CR>
nnoremap <silent> <Space>5          5gt<CR>
nnoremap <silent> <Space>6          6gt<CR>
nnoremap <silent> <Space>7          7gt<CR>
nnoremap <silent> <Space>8          8gt<CR>
nnoremap <silent> <Space>9          9gt<CR>

nnoremap <silent> <Space>.          :w<CR>
nnoremap <silent> <Space>a          <C-w>w<C-w><Bar>z999<CR>
nnoremap <silent> <Space>b          :b#<CR>
nnoremap <silent> <Space>ct         :tabclose<CR>
nnoremap <silent> <Space>c<Space>   :q<CR>
nnoremap <silent> <Space>d          :bd<CR>
nnoremap <silent><expr> <Space>h    (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
map      <silent> <Space>r          g*
vmap     <silent> <Space>r          g*
nnoremap <silent> <Space>l          :GotoLastTab<CR>
nnoremap <silent> <Space>n          :tabnext<CR>

nnoremap <silent> <Space>o          :only<CR>
nnoremap <silent> <Space>O          :tabonly<CR>
nnoremap <silent> <Space>p          :tabprevious<CR>
nnoremap <silent> <Space>t          :tabnew<CR>
nnoremap <silent> <Space>T          :tabclose<CR>

nnoremap <silent> <Space>wh         <C-w>h
nnoremap <silent> <Space>wj         <C-w>j
nnoremap <silent> <Space>wk         <C-w>k
nnoremap <silent> <Space>wl         <C-w>l
nnoremap <silent> <Space>wrj        :resize -5<CR>
nnoremap <silent> <Space>wrk        :resize +5<CR>
nnoremap <silent> <Space>wrh        :vertical resize +5<CR>
nnoremap <silent> <Space>wrl        :vertical resize -5<CR>
nnoremap <silent> <Space>ws         <C-w>s
nnoremap <silent> <Space>wv         <C-w>v

nnoremap <silent> <Space>q          :q<CR>
nnoremap <silent> <Space>x          :qa<CR>
nnoremap <silent> <Space>X          :qa!<CR>
nnoremap <silent> <Space>z          :call ToggleWindowSize()<CR>

nnoremap <silent> <Space><Space>e          :Lexplore<CR>
nnoremap <silent> <Space><Space>f   :call ToggleQuickfixList()<CR>
nnoremap <silent> <Space><Space>w   :set wrap!<CR>
nnoremap <silent> <Space><Space>c   :set cursorline!<CR>:set cursorcolumn!<CR>
nnoremap <silent> <Space><Space>l   :setlocal cursorbind!<CR>:setlocal scrollbind!<CR>:call lightline#update()<CR>
nnoremap <silent> <Space><Space>lc  :setlocal cursorbind!<CR>:call lightline#update()<CR>
nnoremap <silent> <Space><Space>ls  :setlocal scrollbind!<CR>:call lightline#update()<CR>
nnoremap <silent> <Space><Space>r   :set list!<CR>
nnoremap <silent> <Space><Space>x   :Vexplore<CR>
nnoremap <silent> <Space><Space>z   :let &scrolloff=999-&scrolloff<CR>
nnoremap <silent> <Space><Space>\   :call ToggleColorColumn(80)<CR>
nnoremap <silent> <Space><Space>[   :call ToggleColorColumn(120)<CR>
nnoremap <silent> <Space><Space>]   :call ToggleColorColumn(160)<CR>

" vnoremap <Tab>  <Plug>(textobj-capitalchar-next)

" fuzzy go-to definition
function GoToDefinitionAware(target)
  let l:findAny  = '(def\|val\|function\|fun\|fn\|const\|auto\|class\|struct\|object\|trait)\s*' . a:target . '\s*(\W\|$)'
  let l:tmp = g:snugfind_case_sensitive
  let g:snugfind_case_sensitive = 1
  call FindTextRegex(l:findAny)
  let g:snugfind_case_sensitive = l:tmp
endfunction

function GetLineSelection()
    normal gv
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) != 1
        echom 'can read only in-line selection'
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

nnoremap <silent> <Space>s<Space> viw:<C-u>call FindTextFlat(GetLineSelection())<CR>
vnoremap <silent> <Space>s<Space> :<C-u>call FindTextFlat(GetLineSelection())<CR>
vnoremap <silent> <Space>s        :<C-u>call FindTextFlat(GetLineSelection())<CR>
nnoremap <silent> <Space>s        <NOP>
nnoremap <silent> <Space>sr       :call SetFindDir(1, '..')<CR>
nnoremap <silent> <Space>se       :call SetFindDir(1, '')<CR>
nnoremap <silent> <Space>sl       viw:<C-u>:let selectedValue = GetLineSelection()<CR>:call GoToDefinitionAware(selectedValue)<CR>:nohls<CR>:setlocal nowrap<CR>
nmap     <silent> <Space>sj       <Space>sl<C-w><Enter>:call ToggleQuickfixList()<CR><C-w>T

" fuzzy show usages
nnoremap <silent> <Space>su       viw"ty:call FindTextRegex('((with\s\\|extends\s\\|[\(\[])' . getreg('t') . '\\|(?<!def\s\\|val\s\\|ass\s\\|ect\s)' . getreg('t') . '[\)(\[\} ])')<CR>:nohls<CR>

vnoremap r "_dP
vnoremap * y/\V<C-R>"<CR>

tnoremap <C-\><C-\> <C-\><C-n>
tnoremap <silent> <C-\><C-]> <C-\><C-n>:GotoLastTab<CR>

call plug#begin()

let g:quickfix_base_dir = $NVIM_QUICKFIX_BASE_DIR

let g:polyglot_disabled = ['csv', 'csv.plugin']

let g:toggle_list_no_mappings = 1

let g:plug_url_format = "https://git::@github.com/%s.git"
Plug 'itchyny/lightline.vim'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'sindrets/diffview.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'GEverding/vim-hocon'
Plug 'bitc/vim-hdevtools'
" Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'vim-scripts/bufkill.vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'milkypostman/vim-togglelist'
Plug 'kshenoy/vim-signature'
"Plug 'rhysd/open-pdf.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'ojroques/vim-oscyank'
Plug 'tomtom/tcomment_vim'
Plug 'kana/vim-textobj-user'
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
set notermguicolors

let g:oscyank_max_length = 10000000
let g:oscyank_term = 'default'

let g:vim_json_conceal=1

let g:java_highlight_all = 1

let g:gitgutter_map_keys = 0

let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_sort_options = 'i'
let g:netrw_keepdir = 1
let g:netrw_winsize = 20

let g:ranger_map_keys = 0
" let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'

let g:env_variables = {}

map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
let g:asterisk#keeppos = 1

function! LightlineKeymap()
  return !exists("b:keymap_name") ? "" : toupper(b:keymap_name)
endfunction
function! LightlineBindings()
  let value = (&cursorbind ? '[' . (&scrollbind ? '=' : '') . ']': '')
  return (&cursorbind || &scrollbind) ? (value) : ''
endfunction
function! LightlineSnugfind()
  return GetFindSettingsSettings() . " |"
endfunction

function! LightlineLineinfo()
  let aline = getline('.')
  let acol = col('.')
  let charcode = acol - 1 < len(aline) ? printf('0x%02x', char2nr(matchstr(aline[(acol - 1):], '^.'))) : '0x..'
  return printf('%2s', line('.')) . ':' . printf('%2s', charcol('.')) . ' /' . line('$') . ' ' . printf('%6s', charcode)
endfunction

let g:lightline = { 'colorscheme': 'm31', 'filename': "%f", 'tabline': { 'left': [ [ 'tabs' ] ], 'right': [ ] }, 'mode_map': { 'n' : 'N', 'i' : 'I', 'R' : 'R', 'v' : 'V', 'V' : 'L', "\<C-v>": 'B', 'c' : 'C', 's' : 'S', 'S' : 'S-L', "\<C-s>": 'S-B', 't': 'T' }, 'component_function': { 'lineinfo': 'LightlineLineinfo' }, 'component_expand': { 'keymap': 'LightlineKeymap', 'env': 'LightlineEnv', 'snugfind': 'LightlineSnugfind', 'bindings': 'LightlineBindings' }, 'component_type': { 'keymap': 'warning', 'bindings': 'warning' }, 'active': { 'right': [ [], [ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype' ], ['keymap', 'bindings', 'env' ], ['snugfind'] ] }, 'inactive': { 'right': [ [ 'lineinfo' ] ] }, 'subseparator': { 'left': '', 'right': '|' } }

let g:snugfind_dirs = ['.']
if ! empty($NVIM_SEARCH_DIR_1)
  let g:snugfind_dirs += [$NVIM_SEARCH_DIR_1]
endif
let g:snugfind_exclude_dirs = 'project/project,project/target,target,build,.git,.idea,.build,node_modules,tmp,log,frontend/tmp,__pycache__'
let g:snugfind_exclude_files = '.tags,.envrc,.gitbase'
let g:snugfind_verbose = 0

let g:python_highlight_all = 1

if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --follow --ignore={tmp,frontend/tmp,.git,.svn,build,project/project,project/target,target,build,__pycache__} -g "" . ' . (empty($NVIM_SEARCH_DIR_1) ? '' : "'" . $NVIM_SEARCH_DIR_1 . "'")
endif
let g:fzf_colors = { 'fg': ['fg', 'Normal'], 'bg': ['bg', 'Normal'], 'hl': ['fg', 'Comment'], 'fg+': ['fg', 'Normal', 'Comment', 'Normal'], 'bg+': ['bg', 'Normal', 'Normal'], 'hl+': ['fg', 'Statement'], 'info': ['fg', 'PreProc'], 'border': ['fg', 'Ignore'], 'prompt': ['fg', 'Conditional'], 'pointer': ['fg', 'Exception'], 'marker':  ['fg', 'Keyword'], 'spinner': ['fg', 'Label'], 'header':  ['fg', 'Comment'] }
let g:fzf_layout = { 'window': { 'width': 0.88, 'height': 0.88 } }
let g:fzf_history_dir = '~/.local/share/fzf/history'

let g:custom_colorcolumn = { "scala": 120 }

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
command! FormatJSON %!python -m json.tool --indent=2
command! AsJSON set syntax=json | FormatJSON

command! Pipe :w !tmux-pipe-to-next-pane

" need to unmap Tab key for textobj to work in visual mode
unmap <Tab>
call textobj#user#plugin('capitalchar', {
  \  'ncap': { 'pattern': '[A-Z]', 'move-n': ['<Tab>'] },
  \  'pcap': { 'pattern': '[A-Z]', 'move-p': ['<Backspace>'] },
  \})

set virtualedit=all
set nowrap
" set wrap
" set linebreak
set sidescroll=1
set nostartofline
set noshowmode
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start
set ttimeoutlen=0

set list
set listchars=tab:>-,trail:#,extends:>,precedes:<
" set listchars=tab:>-,trail:.,extends:>,precedes:<,eol:¬

"set fillchars+=vert:

set hlsearch
set incsearch
set ignorecase
set smartcase

set cursorlineopt=line,number
set cursorline
if has('nvim')
  set guicursor=n-v-c-sm:block,i-ci-ve:hor25,r-cr-o:ver20
endif
set cursorcolumn
set nocursorcolumn
set showmatch
set number
set numberwidth=4
set linespace=1
set splitbelow
set splitright
set autoread
set foldmethod=indent
set foldlevel=0
set colorcolumn=0
set conceallevel=1
set scrollopt+=hor
set nofoldenable
set signcolumn=yes
set switchbuf=useopen,usetab

set spelllang=en,ru_yo

set tags=./.tags,.tags,./tags,tags

set mouse=a
set so=2
" set clipboard=unnamedplus
set colorcolumn=120

au TermOpen * setlocal nonumber norelativenumber

"au BufRead,BufNewFile * syn match parensCustom /[()]/ | hi! parensCustom ctermfg=15
"au BufRead,BufNewFile * syn match curlyCustom /[{}]/ | hi! curlyCustom ctermfg=10
"au BufRead,BufNewFile * syn match underscoreCustom /[_]/ | hi! underscoreCustom ctermfg=15

function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

au FileType md,latex,tex,md,markdown setlocal spell
au FileType qf nnoremap <buffer> <Space><Enter> <C-w><Enter><C-w>T
au FileType qf nnoremap <buffer> <Enter>        <C-Enter>
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType yaml hi link yamlKey Label
au FileType csv set filetype=
