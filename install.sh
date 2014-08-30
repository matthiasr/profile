#!/bin/sh
#
# Install the base packages I need to feel at home

# Fallback
install_pkg_unknown() {
  echo "Please install" "$@"
}

# "Linux" can be a number of things, treat this specially
install_pkg_linux() {
  if [ -f /etc/debian_version ]
  then
    apt-get install --yes "$@"
  else
    install_pkg_unknown
  fi
}

install_pkg() {
  case "$(uname)" in
    FreeBSD|DragonFly)
      pkg install -y "$@"
      ;;
    OpenBSD)
      pkg_add "$@"
      ;;
    NetBSD|Minix)
      pkgin install "$@"
      ;;
    Linux)
      install_pkg_linux "$@"
      ;;
    *)
      install_pkg_unknown "$@"
      ;;
  esac
}

# Self-rootify
if [ "${USER}" != "root" ]
then
  if which sudo 2>&1 >/dev/null
  then
    exec sudo "$0" "$@"
  elif which pfexec 2>&1 >/dev/null
  then
    exec pfexec "$0" "$@"
  else
    exec su -c "$0 $@"
  fi
fi

install_pkg "$@"
