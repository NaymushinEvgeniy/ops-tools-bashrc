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
#