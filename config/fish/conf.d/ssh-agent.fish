# Based on https://dev.to/d4vsanchez/use-1password-ssh-agent-in-wsl-2j6m

if type -q npiperelay.exe # We are on WSL2, set up the agent
    # Configure ssh forwarding
    mkdir -p ~/.1password
    set -x SSH_AUTH_SOCK $HOME/.1password/agent.sock # Using the same socket name as with native Linux
    # need `ps -ww` to get non-truncated command for matching
    # use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
    if ! ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"
        if [ -S $SSH_AUTH_SOCK ]
            # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
            echo "removing previous socket..."
            rm $SSH_AUTH_SOCK
        end
        echo "Starting SSH-Agent relay..."
        # setsid to force new session to keep running
        # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
        fish -c 'setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &' >/tmp/socat.log 2>&1
    end
end

switch (uname -s)
case Darwin
    set -x SSH_AUTH_SOCK "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
case Linux
    set -x SSH_AUTH_SOCK "~/.1password/agent.sock"
end
