#!/usr/bin/env bash

# Check interactive mode
imode=$(expr index "$-" i)

#######################################################
# SETUP SOURCED DEFINITIONS
#######################################################

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Bash autocomplete:
# https://github.com/scop/bash-completion

if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

#######################################################
# EXPORTS
######################################################

# History size
export HISTFILE=10000
export HISTSIZE=1000

# Disable duplicate lines in the history, don't add lines that start with space
export HISTCONTROL=ignoreboth:erasedups

# Don't save command like ls,ps,history
export HISTIGNORE='ls:ps:history'

# Date format for history
export HISTTIMEFORMAT='%d.%m.%Y %H:%M:%S: '

# Enable write history to $HISTFILE
shopt -s histappend
PROMPT_COMMAND='history -a'

# Check the widnow size after each command
shopt -s checkwinsize

# Enable find in history with CTRL+R (reverse) or CTRL-S
stty -ixon