execute pathogen#infect()

" new window with a shell
nmap :sh                  :source ~/.vim/vimsh.vim

set autoindent
set autoread
set expandtab
set lbr "soft wrap lines at word boundaries
set number "line numbering

filetype plugin indent on
syntax on

" Make ',e' (in normal mode) give a prompt for opening files
" in the same dir as the current buffer's file.
if has("unix")
  map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
  map ,e :e <C-R>=expand("%:p:h") . "\\" <CR>
endif

"Vertical split then hop to new buffer
:noremap ,v :vsp^M^W^W
:noremap ,h :split^M^W^W
"Make current window the only one
:noremap ,O :only^M:tabo^M
:noremap ,o :only^M

"Buffer next,previous (ctrl-{n,p})
:noremap ^N :bn^M
:noremap ^P :bp^M
"Buffer delete (ctrl-c)
:noremap ^C :bd^M

"Taglist
:noremap <F8> :TlistToggle<CR>
:let Tlist_Show_Menu=1

"Escape alternatives
:inoremap jj <ESC>
":inoremap ;; <ESC>

"SoundCloud conventions
set et sw=2 ts=2 sts=2
highlight ExtraWhitespace ctermfg=15 ctermbg=4 guifg=#CF6A4C guibg=#420E09
match ExtraWhitespace /\s\+$\| \+\ze\t/

" GitHub flavored Markdown
" augroup markdown
"   au!
"   au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
" augroup END

" look for modelines
set modelines=3

set background=dark

" more memory for searches/patterns
set maxmempattern=20480

" disable auto-format on save for Go
"let g:go_fmt_autosave = 0

" Expand folds by default
set foldlevel=99

" More shell-like tab completion
set wildmode=longest,list,full
set wildmenu

" do not create double spaces when joining lines
set nojoinspaces

" recommended settings from https://github.com/fatih/vim-go-tutorial
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

"autocmd FileType go nmap <Leader>i <Plug>(go-info)
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1

let g:rustfmt_autosave = 1

let g:terraform_fmt_on_save = 1

" https://github.com/vim-syntastic/syntastic#3-recommended-settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
