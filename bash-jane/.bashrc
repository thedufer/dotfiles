#!/bin/bash

if [[ -f /etc/bashrc ]]; then
  source /etc/bashrc
fi

if [[ -e /etc/jane/shared/bashrc ]]; then
  source /etc/jane/shared/bashrc
elif [[ -e /mnt/global/dev/etc/shared/bashrc ]]; then
  source /mnt/global/dev/etc/shared/bashrc
fi

PATH=$HOME/bin:$PATH
export PATH
#added by dispatch - v2
export PATH=/home/adufour/.dispatch/bin:$PATH
/usr/bin/dispatch auto-update

## My stuff

# Contains cdf
. /j/office/app/fe/prod/etc/bashrc

# Don't cap hist size
export HISTSIZE=10000000
export HISTFILESIZE=10000000

# Share Kerberos credentials between sessions
function make_krb5_collection {
  ccdir=${1}
  if mkdir -p ${ccdir}; then
    chmod 700 ${ccdir}
    if klist -s; then
      existing=$(echo $KRB5CCNAME | sed -e 's!FILE:!!')
      [[ -f "${existing}" ]] && cp ${existing} ${ccdir}/tkt
    fi
  fi
}

case "${KRB5CCNAME}" in
  FILE:*)
    ccdir=/tmp/krb5_collection_$(id -u)
    klist -s -c DIR:${ccdir} || make_krb5_collection ${ccdir}
    export KRB5CCNAME=DIR:${ccdir}
    ;;
  *)
    ;;
esac

# Set up PS1
export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
  local EXIT="$?"
  RED="\[$(tput setaf 1)\]"
  BOLD="\[$(tput bold)\]"
  RESET="\[$(tput sgr0)\]"

  # Put $HOSTNAME in the title
  PS1="\[\033]0;$HOSTNAME\007\][\t "

  # Prompts for password is there are no Kerberos credentials
  if ! klist -s; then
    kinit
  fi

  PS1+="\u$RESET@\h \W]"

  if [ "$EXIT" -ne 0 ]; then
    PS1+=$RED$BOLD
  fi
  PS1+="\$$RESET "
}

# Useful functions

function proddb {
  psql -h postgresmaster -d proddb -U $(whoami) "$@"
}

export LESS=" -R "

alias uid="ssh igm-qws-u12564a"
