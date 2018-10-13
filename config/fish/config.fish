fish_hybrid_key_bindings
set CDPATH . ~ ~/src/github.com/
set fish_greeting ""

if test -f ~/.rvm/scripts/rvm
    rvm default
end

for d in ~/bin ~/go/bin ~/.cargo/bin
    if test -d $d
        set fish_user_paths $fish_user_paths $d
    end
end
set -x GOPATH $HOME
set -x EDITOR vim

if command -v docker-machine > /dev/null
    eval (docker-machine env default --shell fish)
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

