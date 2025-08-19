#!/usr/bin/env bash

# Check interactive mode (for disable all parametrs of .bashrc in scripts, like ./myscript, cron, etc)
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
# DEVOPS ALIAS'S
#######################################################

# Eza (A modern replacement for ls): https://github.com/eza-community/eza
# Install Eza on Ubuntu/Debian:
# sudo mkdir -p /etc/apt/keyrings
# wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
# echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
# sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
# sudo apt update
# sudo apt install -y eza
if [ -f /usr/bin/eza ]; then
	alias le="eza --icons=always --tree --level=1"
fi

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'

# Custom date
alias da='date "+%Y-%m-%d %A %T %Z"'
# My custom aliases:
alias cls="clear"
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -iv'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias apt='sudo apt'
alias vi='vim'
alias svi='sudo vi'

# Change directory
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Change to previos directory
alias bd='cd "$OLDPWD"'

# Alias's for multiple directory listing commands
alias la='ls -Alh' # show hidden files
alias lx='ls -lXBh' # sort by extension

# Search in hisory
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Show disk usage in a folder
alias diskspace="du -S | sort -n -r | more"

# Work with archives
alias mktar='tar -cvf'
alias untar='tar -xvf'

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

# Disable the bell in autocomplete
if [[ $imode > 0 ]]; then bind "set bell-style visible"; fi

# Ignore Upper and Lower case
if [[ $imode > 0 ]]; then bind "set completion-ignore-case on"; fi

# One press Tab for Autocompleet
if [[ $imode > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

#######################################################
# Customizing PROMPT
#######################################################

alias cpu="grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage}' | awk '{printf(\"%.1f\n\", \$1)}'"

function __setprompt
{
	local LAST_COMMAND=$? # Must come first!

	# Define colors
	local LIGHTGRAY="\033[0;37m"
	local WHITE="\033[1;37m"
	local BLACK="\033[0;30m"
	local DARKGRAY="\033[1;30m"
	local RED="\033[0;31m"
	local LIGHTRED="\033[1;31m"
	local GREEN="\033[0;32m"
	local LIGHTGREEN="\033[1;32m"
	local BROWN="\033[0;33m"
	local YELLOW="\033[1;33m"
	local BLUE="\033[0;34m"
	local LIGHTBLUE="\033[1;34m"
	local MAGENTA="\033[0;35m"
	local LIGHTMAGENTA="\033[1;35m"
	local CYAN="\033[0;36m"
	local LIGHTCYAN="\033[1;36m"
	local NOCOLOR="\033[0m"

	# Show error exit code if there is one
	if [[ $LAST_COMMAND != 0 ]]; then
		PS1="\[${DARKGRAY}\](\[${LIGHTRED}\]ERROR\[${DARKGRAY}\])-(\[${RED}\]Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${DARKGRAY}\])-(\[${RED}\]"
		if [[ $LAST_COMMAND == 1 ]]; then
			PS1+="General error"
		elif [ $LAST_COMMAND == 2 ]; then
			PS1+="Missing keyword, command, or permission problem"
		elif [ $LAST_COMMAND == 126 ]; then
			PS1+="Permission problem or command is not an executable"
		elif [ $LAST_COMMAND == 127 ]; then
			PS1+="Command not found"
		elif [ $LAST_COMMAND == 128 ]; then
			PS1+="Invalid argument to exit"
		elif [ $LAST_COMMAND == 129 ]; then
			PS1+="Fatal error signal 1"
		elif [ $LAST_COMMAND == 130 ]; then
			PS1+="Script terminated by Control-C"
		elif [ $LAST_COMMAND == 131 ]; then
			PS1+="Fatal error signal 3"
		elif [ $LAST_COMMAND == 132 ]; then
			PS1+="Fatal error signal 4"
		elif [ $LAST_COMMAND == 133 ]; then
			PS1+="Fatal error signal 5"
		elif [ $LAST_COMMAND == 134 ]; then
			PS1+="Fatal error signal 6"
		elif [ $LAST_COMMAND == 135 ]; then
			PS1+="Fatal error signal 7"
		elif [ $LAST_COMMAND == 136 ]; then
			PS1+="Fatal error signal 8"
		elif [ $LAST_COMMAND == 137 ]; then
			PS1+="Fatal error signal 9"
		elif [ $LAST_COMMAND -gt 255 ]; then
			PS1+="Exit status out of range"
		else
			PS1+="Unknown error code"
		fi
		PS1+="\[${DARKGRAY}\])\[${NOCOLOR}\]\n"
	else
		PS1=""
	fi

	# External IP
	PS1_CMD1="\[${YELLOW}\]$(ip route get 1.1.1.1 | awk '{print $7}')"
	# CPU
	PS1_CMD2="\[${WHITE}\]|CPU $(cpu)%"
	# Homecatalog with formating
	PS1_CMD3="(\[\e[4m\]\w\[\e[0m\])"
	# Date
	#PS1_CMD4="\[${DARKGRAY}\](\[${CYAN}\]\$(date +%a) $(date +%b-'%-m')"
	PS1_CMD4="(\[${CYAN}\]$(date '+%a %d %B %Y')"

	# Time
	PS1_CMD5="${CYAN} $(date +'%-I':%M:%S%P)\[${WHITE}\])"
	# Summary Naming
	# \u - username; \H - hostname; \w -home catalog
	PS1+="[\[${RED}\]\u\[${WHITE}\]@\H|${PS1_CMD1}${PS1_CMD2}] ${PS1_CMD3} ${PS1_CMD4} ${PS1_CMD5}"

	# Skip to the next line
	PS1+="\n"
	# Color arrow (>) in the begin command line
	if [[ $EUID -ne 0 ]]; then
		PS1+="\[${GREEN}\]>\[${NOCOLOR}\] " # Normal user
	else
		PS1+="\[${RED}\]>\[${NOCOLOR}\] " # Root user
	fi

	# PS2 is used to continue a command using the \ character
	PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "

	# PS3 is used to enter a number choice in a script
	PS3='Please enter a number from above list: '

	# PS4 is used for tracing a script in debug mode
	PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
}

PROMPT_COMMAND='__setprompt'

# Default editor
if [ -f /usr/bin/vim ]; then
	export EDITOR=vim
	export VISUAL=vim
fi

#######################################################
# SPECIAL FUNCTIONS
#######################################################
# Extracts any type of archive(s)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Copy file with a progress bar
cpp()
{
	set -e
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
	| awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
}

# Copy and go to the directory
cpg ()
{
	if [ -d "$2" ];then
		cp $1 $2 && cd $2
	else
		cp $1 $2
	fi
}

# Move and go to the directory
mvg ()
{
	if [ -d "$2" ];then
		mv $1 $2 && cd $2
	else
		mv $1 $2
	fi
}