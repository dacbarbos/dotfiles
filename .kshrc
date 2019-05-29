# RTFM https://www.ibm.com/support/knowledgecenter/ssw_aix_71/com.ibm.aix.osdevice/korn_shell.htm
# AIX Korn Shell environment
#      shell            initializations go in ~/.kshrc
#      user             initializations go in ~/.profile
#      host / all_user  initializations go in /etc/profile
#      hard / software  initializations go in /etc/environment
# DEBUG=y       # uncomment to report
[ "$DEBUG" ] && echo "Entering .kshrc"
# set some shell options
set -o emacs -o trackall
set -o allexport
# LIBPATH must be here because ksh is setuid, and LIBPATH is
# cleared when setuid programs are started, due to security hole.
LIBPATH=.:/local/lib:/lib:/usr/lib
HOSTNAME=$(uname -n)
TTY=$(tty|cut -f3-4 -d/)
HISTFILE=$HOME/.sh_hist$(echo ${TTY} | tr -d '/')
HISTSIZE=1024
HISTEDIT=$EDITOR
PWD=$(pwd)
PS1='${LOGNAME}@${HOSTNAME}:${PWD}> '
# aliases
[ "$DEBUG" ] && echo "Setting aliases"
alias __A=$(print '\0020') # ^P = up = previous command
alias __B=$(print '\0016') # ^N = down = next command
alias __C=$(print '\0006') # ^F = right = forward a character
alias __D=$(print '\0002') # ^B = left = back a character
alias __H=$(print '\0001') # ^A = home = beginning of line
alias a='alias'
alias c='tput clear'
alias g='grep'
alias h='history'
alias m='more'
alias t='tail'
alias la='ls -al'
alias ll='ls -l'
alias rsz='eval $(resize)'
alias sane='stty sane'
alias susu='sudo su -'
# aixterm window title
[[ "$TERM" = "aixterm" ]] && echo "\033]0;$USER@${HOSTNAME%t1}\007"
# functions
[ "$DEBUG" ] && echo "Setting functions"
function pid { ps -e | grep $@ | cut -d" " -f1; }
[ "$DEBUG" ] && echo "Exiting .kshrc"
set +o allexport
