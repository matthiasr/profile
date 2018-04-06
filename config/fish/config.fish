fish_hybrid_key_bindings
set CDPATH . ~/src/github.com/
set fish_greeting ""

if test -f ~/.rvm/script/rvm
    rvm default
end

set -x GOPATH $HOME
set -x PATH ~/bin ~/.cargo/bin $PATH
set -x EDITOR vim

if command -v docker-machine > /dev/null
    eval (docker-machine env default --shell fish)
end
