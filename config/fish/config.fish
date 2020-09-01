fish_hybrid_key_bindings
set CDPATH . ~ ~/src/github.com/
set fish_greeting ""

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

test -e {$HOME}/.iterm2_shell_integration.fish
and source {$HOME}/.iterm2_shell_integration.fish

# https://github.com/aws/aws-cli/issues/1079#issuecomment-252947755
test -x (which aws_completer)
and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# https://github.com/fish-shell/fish-shell/issues/825#issuecomment-203021964
function save_history --on-event fish_preexec
    history --save
end

# rbenv & pyenv
status --is-interactive
and type -q rbenv
and source (rbenv init -|psub)
status --is-interactive
and type -q pyenv
and source (pyenv init -|psub)

# load full SDK config (mostly for Terraform < 0.13)
set -x AWS_SDK_LOAD_CONFIG 1
