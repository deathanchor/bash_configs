# ~/.bashrc: executed by bash(1) for non-login shells.

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If not running interactively, don't do anything:
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# use vi style command line editing
set -o vi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# so screen doesn't screw with your ssh agent forwarding
if [ ! -z "$SSH_AUTH_SOCK" ]; then
    screen_ssh_agent=${HOME}/.ssh-agent-screen
    if [ "$TERM" == "screen" ]; then
        export SSH_AUTH_SOCK=${screen_ssh_agent}; 
    else
        ln -snf ${SSH_AUTH_SOCK} ${screen_ssh_agent}
    fi
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profiles
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# addiitonal complete commands
if [ -d /etc/bash_completion.d/ ]; then
    for file in /etc/bash_completion.d/*.bash /etc/bash_completion.d/git
    do
        #echo "Loading $file"
        . $file
    done
fi


# how big do you need your history really?
export HISTFILESIZE=500
export HISTSIZE=500
export HISTFILE=~/.history


## some common alias shorthand
alias dc='cd'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ll='ls -l'
alias lt='ls -tr'
alias llt='ls -ltr'
alias la='ls -ltra'
alias ls='ls --color=auto -F'
alias lo='ls -lt'
alias lh='ls -lh'
alias llth='ls -lthr'
alias lah='ls -ltrha'
alias mnow='find `pwd` -mmin -60'
alias mtoday='find `pwd` -mtime -1'
alias cnow='find `pwd` -cmin -60'
alias ctoday='find `pwd` -ctime -1'

alias pd='pushd'
alias pop='popd'

alias countfiles='for i in `find * -maxdepth 0 -type d`; do echo -n "$i "; find $i -type f 2>/dev/null  | wc -l; done | egrep -v " 0$"'
alias count='sort | uniq -c | sort -n'

alias finf='find `pwd` \( -name .git -prune \) -o -print0 2>/dev/null | xargs -0 egrep '
alias ff='find `pwd` \( -name .git -prune \) -o -print 2>/dev/null | egrep '

# loop controls
alias goon='while true; do' # mnemonic "Go on..."
alias s30='sleep 30; done'
alias s1='sleep 1; done'


# ENV settings
export EDITOR="vim"
export LESS="-j15 -e -i -M -R -X"
export PAGER="less"
export GREP_COLOR='1;33' # highlight matches
export GREP_OPTIONS='--color=auto' # auto color

# extended bash regex @(this|that), ?(either|of|none) !(not)
shopt -s extglob

# don't tab complete files with these extentions for cat command
complete -o default -f -X '*@(.Z|.gz|.zip|.rpm|.pdf|.wmv|.tar|.jpg|.png|.gif)' cat

# use known hosts for tab completing these commands
# requires /etc/bash_completion.d/ssh.bash
complete -o default -o nospace -F _ssh scp
complete -o default -o nospace -F _ssh mongo

# highlights searched text
# cat file | hl searchtext
function hl() { egrep --color -e "$@" -e '$'; }

