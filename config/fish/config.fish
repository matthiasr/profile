fish_hybrid_key_bindings
set CDPATH . ~/src/github.com/
set fish_greeting ""

rvm default

set -x GOPATH $HOME
set -x PATH ~/bin $PATH
set -x EDITOR vim
eval (docker-machine env default --shell fish)
