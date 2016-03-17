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

# Make PS1 loud when there are no Kerberos credentials
export PROMPT_COMMAND=__prompt_command

function __prompt_command() {
  RED="\[$(tput setaf 1)\]"
  RESET="\[$(tput sgr0)\]"

  PS1="[\t "

  if ! klist 2>/dev/null | grep $(whoami)@DELACY.COM >/dev/null; then
    PS1+=$RED
  fi

  PS1+="\u$RESET@\h \W]\$ "
}

function proddb {
  psql -h postgresmaster -d proddb -U $(whoami) "$@"
}
