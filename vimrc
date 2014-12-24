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
augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" look for modelines
set modelines=3

set background=dark

" more memory for searches/patterns
set maxmempattern=20480
