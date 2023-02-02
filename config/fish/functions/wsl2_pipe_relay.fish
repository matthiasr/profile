function wsl2_pipe_relay --argument-names winpipe linuxsocket --description 'Set up npiperelay forwarding between a named Windows pipe and Linux in WSL2.'
    # Silently do nothing if npiperelay is not available, we are probably not in WSL2.
    if ! type -q npiperelay.exe
    echo skip
        return
    end

    # Check if the relay is already running. Matching on `[s]ocat` prevents the grep itself from showing up in the search.
    if ! ps -auxww | grep -q "[s]ocat UNIX-LISTEN:$linuxsocket"
        if test -S $linuxsocket
            # Remove the previous socket as nobody is listening
            rm $linuxsocket
        end
        # set socat to listen on $linuxsocket and forward to npiperelay which then forwards to $winpipe on windows
        # By using setsid, this becomes independent from the initial terminal that starts it up.
        setsid --fork socat UNIX-LISTEN:$linuxsocket,fork EXEC:"npiperelay.exe -ei -s $winpipe",nofork >/dev/null 2>&1
    end
end
