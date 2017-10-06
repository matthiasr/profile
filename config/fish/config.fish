fish_hybrid_key_bindings
set CDPATH . ~/src/github.com/
set fish_greeting ""

which rvm >/dev/null 2>/dev/null; and rvm default

set -x GOPATH $HOME
set -x PATH ~/bin $PATH
