function rvm --description='Ruby enVironment Manager'
  # run RVM and capture the resulting environment
  set --local env_file (mktemp -t rvm.fish.XXXXXXXXXX)
  set --local rvm_path_temp

  # This finds where RVM's root directory is and sources scripts/rvm from within it.  Then loads RVM in a clean environment and dumps the environment variables it generates out for us to use. 
  bash -c 'PATH=$GEM_HOME/bin:$PATH;RVMA=$(which rvm);RVMB=$(whereis rvm | sed "s/rvm://");source $(if test $RVMA;then echo $RVMA | sed "s/\/bin\//\/scripts\//";elif test $RVMB; then echo $RVMB | sed "s/rvm/rvm\/scripts\/rvm/"; else echo ~/.rvm/scripts/rvm; fi); rvm "$@"; status=$?; env > "$0"; exit $status' $env_file $argv

  # apply rvm_* and *PATH variables from the captured environment
  and eval (grep -E '^rvm|^GEM_PATH|^GEM_HOME' $env_file | grep -v '_clr=' | sed '/^[^=]*PATH/s/:/" "/g; s/^/set -xg /; s/=/ "/; s/$/" ;/; s/(//; s/)//')
  # apply only the RVM specific parts of PATH. First load the whole RVM-manipulated PATH into an array, then merge all items that are not within the rvm_path from PATH with those that are from the RVM environment.
  and eval (grep -E '^PATH=' $env_file | grep -v '_clr=' | sed '/^PATH=/s/:/" "/g; s/^PATH=/set rvm_path_temp "/; s/$/" ;/; s/(//; s/)//')
  and set PATH (string match "$rvm_path/*" $rvm_path_temp) (string match -v "$rvm_path/*" $PATH)
  # needed under fish >= 2.2.0
  and set -xg GEM_PATH (echo $GEM_PATH | sed 's/ /:/g')

  # clean up
  set -u rvm_path_temp
  rm -f $env_file
end

function __handle_rvmrc_stuff --on-variable PWD
  # Source a .rvmrc file in a directory after changing to it, if it exists.
  # To disable this feature, set rvm_project_rvmrc=0 in $HOME/.rvmrc
  if test "$rvm_project_rvmrc" != 0
    set -l cwd $PWD
    while true
      if contains $cwd "" $HOME "/"
        if test "$rvm_project_rvmrc_default" = 1
          rvm default 1>/dev/null 2>&1
        end
        break
      else
        if test -e .rvmrc -o -e .ruby-version -o -e .ruby-gemset
          eval "rvm reload" > /dev/null
          eval "rvm rvmrc load" >/dev/null
          break
        else
          set cwd (dirname "$cwd")
        end
      end
    end

    set -e cwd
  end
end
