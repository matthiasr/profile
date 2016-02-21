# color definitions
autoload colors && colors
BLUE="%{${fg[blue]}%}"
RED="%{${fg_bold[red]}%}"
GREEN="%{${fg[green]}%}"
CYAN="%{${fg[cyan]}%}"
MAGENTA="%{${fg[magenta]}%}"
YELLOW="%{${fg[yellow]}%}"
WHITE="%{${fg[white]}%}"
NO_COLOUR="%{${reset_color}%}"

autoload vcs_info
zstyle ':vcs_info:*' max-exports 2

if [[ "$TERM" == dumb ]] ; then
    zstyle ':vcs_info:*' actionformats "(%s%)-[%b|%a] " "zsh: %r"
    zstyle ':vcs_info:*' formats       "(%s%)-[%b] "    "zsh: %r"
else
    # these are the same, just with a lot of colours:
    zstyle ':vcs_info:*' actionformats "${MAGENTA}(${NO_COLOUR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${YELLOW}|${RED}%a${MAGENTA}]${NO_COLOUR} " "zsh: %r"
    zstyle ':vcs_info:*' formats       "${MAGENTA}(${NO_COLOUR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${MAGENTA}]${NO_COLOUR}%} " "zsh: %r"
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b${RED}:${YELLOW}%r"
fi

autoload promptinit && promptinit
setopt transient_rprompt
setopt prompt_subst


function ESC_print () {
    info_print $'\ek' $'\e\\' "$@"
}
function set_title () {
    info_print  $'\e]0;' $'\a' "$@"
}

function info_print () {
    local esc_begin esc_end
    esc_begin="$1"
    esc_end="$2"
    shift 2
    printf '%s' ${esc_begin}
    printf '%s' "$*"
    printf '%s' "${esc_end}"
}

# TODO: revise all these NO* variables and especially their documentation
#       in zsh-help() below.
precmd () {
    # update VCS information
    (( ${+functions[vcs_info]} )) && vcs_info

    RPROMPT="%(?..:() "

    case $TERM in
        (xterm*|rxvt*)
            set_title ${(%):-"%n@%m: %~"}
            ;;
        (screen*)
            if [[ -n ${vcs_info_msg_1_} ]] ; then
                ESC_print ${vcs_info_msg_1_}
            else
                ESC_print "zsh"
            fi
            ;;
    esac
}

preexec () {
    NAME="@$HOSTNAME"
    case $TERM in
        (xterm*|rxvt*)
            set_title "${(%):-"%n@%m:"}" "$1"
            ;;
        (screen*)
            local CMD="${1[(wr)^(*=*|sudo|ssh|-*)]}$NAME" # use hostname
            ESC_print ${CMD}
            ;;
    esac
}

EXITCODE="%(?..%?%1v )"
# secondary prompt, printed when the shell needs more information to complete a
# command.
PS2='\`%_> '
# selection prompt used within a select loop.
PS3='?# '
# the execution trace prompt (setopt xtrace). default: '+%N:%i>'
PS4='+%N:%i:%_> '

# don't use colors on dumb terminals (like emacs):
if [[ "$TERM" == dumb ]] ; then
    PROMPT="${EXITCODE}%n@%m %40<...<%B%~%b%<< "
else
      # This assembles the primary prompt string
      if (( EUID != 0 )); then
          PROMPT="${RED}${EXITCODE}${WHITE}${BLUE}%n${NO_COLOUR}@%m %40<...<%B%~%b%<< "
      else
          PROMPT="${BLUE}${EXITCODE}${WHITE}${RED}%n${NO_COLOUR}@%m %40<...<%B%~%b%<< "
    fi
fi

PROMPT="${PROMPT}"'${vcs_info_msg_0_}'"%# "

# XXX review
setopt append_history
setopt share_history
setopt extended_history
#setopt histignorealldups
#setopt extended_glob
setopt longlistjobs
setopt nonomatch
setopt notify
setopt hash_list_all
setopt completeinword
#setopt nohup
setopt auto_pushd
setopt autocd
setopt nobeep
setopt pushd_ignore_dups
setopt noglobdots
setopt noshwordsplit
setopt unset

[[ -r /etc/default/locale ]] && source /etc/default/locale
for var in LANG LC_ALL LC_MESSAGES ; do
    [[ -n ${(P)var} ]] && export $var
done

# XXX set up PATH first?
if [[ $TERM == dumb ]]; then
  export EDITOR=ed
elif which vim 2>&1 >/dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

export PAGER=less

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5

# watch for everyone but me and root
watch=(notme root)

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# keybindings
if [[ "$TERM" != emacs ]] ; then
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
    [[ -z "$terminfo[kend]"  ]] || bindkey -M emacs "$terminfo[kend]"  end-of-line
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
    [[ -z "$terminfo[kend]"  ]] || bindkey -M vicmd "$terminfo[kend]"  vi-end-of-line
    #[[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  vi-up-line-or-history
    #[[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  up-line-or-history
    [[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  up-line-or-search
    [[ -z "$terminfo[cuf1]"  ]] || bindkey -M viins "$terminfo[cuf1]"  vi-forward-char
    #[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
    #[[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-history
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" up-line-or-search
    #[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
    #[[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" down-line-or-search
    [[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
    [[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char
    # ncurses stuff:
    #[[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
    #[[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-history
    [[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" up-line-or-search
    #[[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
    #[[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-history
    [[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" down-line-or-search
    [[ "$terminfo[kcuf1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
    [[ "$terminfo[kcub1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
    [[ "$terminfo[khome]" == $'\eO'* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]"  == $'\eO'* ]] && bindkey -M viins "${terminfo[kend]/O/[}"  end-of-line
    [[ "$terminfo[khome]" == $'\eO'* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]"  == $'\eO'* ]] && bindkey -M emacs "${terminfo[kend]/O/[}"  end-of-line
    bindkey "^R" history-incremental-search-backward
fi

#m# k Shift-tab Perform backwards menu completion
if [[ -n "$terminfo[kcbt]" ]]; then
    bindkey "$terminfo[kcbt]" reverse-menu-complete
elif [[ -n "$terminfo[cbt]" ]]; then # required for GNU screen
    bindkey "$terminfo[cbt]"  reverse-menu-complete
fi

bindkey -v

autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle ':url-quote-magic:*' url-metas '*?[]^()~#{}='


autoload compinit
compinit

autoload zed

zmodload -i zsh/complist
zmodload -i zsh/mathfunc

#k# menu selection: pick item but stay in the menu
bindkey -M menuselect '\e^M' accept-and-menu-complete
# also use + and INSERT since it's easier to press repeatedly
bindkey -M menuselect "+" accept-and-menu-complete
bindkey -M menuselect "^[[2~" accept-and-menu-complete

# accept a completion and try to complete again by using menu
# completion; very useful with completing directories
# by using 'undo' one's got a simple file browser
bindkey -M menuselect '^o' accept-and-infer-next-history

# run command line as user root via sudo:
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N sudo-command-line

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=100000

DIRSTACKSIZE=20
DIRSTACKFILE=$HOME/.zdirs

typeset -ga ls_options
typeset -ga grep_options
case "$(uname)" in
  FreeBSD|Darwin|DragonFly)
    ls_options=( -G -b )
    grep_options=( --color=auto )
    ;;
  *)
    if ls --help 2> /dev/null | grep -q GNU; then
        ls_options=( --color=auto -b )
    fi
    if grep --help 2> /dev/null | grep -q GNU; then
        grep_options=( --color=auto )
    fi
esac

export CLICOLOR=1 # no harm to set this everywhere
export COLORTERM="yes"
if [[ "$TERM" != dumb ]]; then
    alias ls='ls -CF '${ls_options:+"${ls_options[*]}"}
    alias la='ls -la '${ls_options:+"${ls_options[*]}"}
    alias ll='ls -l '${ls_options:+"${ls_options[*]}"}
    alias lh='ls -hAl '${ls_options:+"${ls_options[*]}"}
    alias l='ls -lF '${ls_options:+"${ls_options[*]}"}
else
    alias ls='ls -CF'
    alias la='ls -la'
    alias ll='ls -l'
    alias lh='ls -hAl'
    alias l='ls -lF'
fi

alias ...='cd ../../'

if which ack-grep 2>&1 >/dev/null
then
  alias ack=ack-grep
fi

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*'               menu select=5

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
#zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin        \
                                           /sbin           \
                                           /bin            \
                                           /usr/X11R6/bin

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# run rehash on completion so new installed program are found automatically:
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1
}

# try to be smart about when to use what completer...
setopt correct
zstyle -e ':completion:*' completer '
    if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
        _last_try="$HISTNO$BUFFER$CURSOR"
        reply=(_complete _match _ignored _prefix _files)
    else
        if [[ $words[1] == (rm|mv) ]] ; then
            reply=(_complete _files)
        else
            reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
        fi
    fi'

# command for process lists, the local web server details and host completion
zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

# caching
[[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
                        zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

# host completion
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
    $(hostname)
    "$_ssh_hosts[@]"
    "$_etc_hosts[@]"
    grml.org
    localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp deborphan df feh fetchipac head hnb ipacsum mv \
               pal stow tail uname ; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

# see upgrade function in this file
compdef _hosts upgrade

alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
alias insecscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'

alias please='sudo -- $(fc -ln -1 -1)'

cd() {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

# Create Directoy and \kbd{cd} to it
mkcd() {
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1"
}

# Create temporary directory and \kbd{cd} to it
cdt() {
    local t
    t=$(mktemp -d)
    echo "$t"
    builtin cd "$t"
}

# Create small urls via http://goo.gl using curl(1).
# API reference: https://code.google.com/apis/urlshortener/
function zurl() {
    emulate -L zsh
    if [[ -z $1 ]]; then
        print "USAGE: zurl <URL>"
        return 1
    fi

    local PN url prog api json data
    PN=$0
    url=$1

    # Prepend 'http://' to given URL where necessary for later output.
    if [[ ${url} != http(s|)://* ]]; then
        url='http://'${url}
    fi

    if check_com -c curl; then
        prog=curl
    else
        print "curl is not available, but mandatory for ${PN}. Aborting."
        return 1
    fi
    api='https://www.googleapis.com/urlshortener/v1/url'
    contenttype="Content-Type: application/json"
    json="{\"longUrl\": \"${url}\"}"
    data=$($prog --silent -H ${contenttype} -d ${json} $api)
    # Match against a regex and print it
    if [[ $data =~ '"id": "(http://goo.gl/[[:alnum:]]+)"' ]]; then
        print $match;
    fi
}

[ -r $HOME/.profile ] && source $HOME/.profile
[ -r ${HOME}/.ssh/profile ] && source ${HOME}/.ssh/profile

for p in "${HOME}/bin" "${HOME}/go/bin" "${HOME}/.rvm/bin"
do
  if [ -d "${p}" ]
  then
    export PATH="${p}:${PATH}"
  fi
done
