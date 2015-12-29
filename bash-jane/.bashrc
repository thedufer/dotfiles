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
