# Based on https://dev.to/d4vsanchez/use-1password-ssh-agent-in-wsl-2j6m

switch (uname -s)
case Darwin
    set -x SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
case Linux
    set -x SSH_AUTH_SOCK $HOME/.1password/agent.sock
    # On WSL2, set up the relay to the Windows 1Password
    mkdir -p $HOME/.1password
    wsl2_pipe_relay //./pipe/openssh-ssh-agent $SSH_AUTH_SOCK
end
