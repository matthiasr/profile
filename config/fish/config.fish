fish_hybrid_key_bindings
set CDPATH . ~ ~/src/github.com/
set fish_greeting ""

if test -f ~/.rvm/scripts/rvm
    rvm default
end

if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

for d in ~/bin ~/go/bin ~/.cargo/bin
    if test -d $d
        set fish_user_paths $fish_user_paths $d
    end
end

ssh-add -L >/dev/null 2>/dev/null
if [ $status -eq 2 ]
  pkill -u (whoami) ssh-agent
  eval (ssh-agent -c)
end

set -x EDITOR vim

if command -v docker-machine > /dev/null
    eval (docker-machine env default --shell fish)
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# https://github.com/aws/aws-cli/issues/1079#issuecomment-252947755
test -x (which aws_completer); and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
