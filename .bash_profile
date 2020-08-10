#!/bin/env bash
#$HOME/.bash_profile || $HOME/.bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
if [ "$PS1" != "" ] && [ "${STARTED_SCREEN:-x}" = x ] && [ "${SSH_TTY:-x}" != x ]
then
  STARTED_SCREEN=1 ; export STARTED_SCREEN
  [ -d $HOME/.local/var/screen-logs ] || mkdir -p $HOME/.local/var/screen-logs
  sleep 1
  screen -RR && exit 0
  # normally, execution of this rc script ends here...
  echo "Screen failed! continuing with normal bash startup"
fi

#-------------------------------------------------------------
# Source global definitions (if any)
#-------------------------------------------------------------
# shellcheck source=/dev/null
if [ -f /etc/bashrc ]; then
      . /etc/bashrc   # --> Read /etc/bashrc, if present.
fi

#--------------------------------------------------------------
#  Automatic setting of $DISPLAY (if not set already).
#  This works for me - your mileage may vary. . . .
#  The problem is that different types of terminals give
#+ different answers to 'who am i' (rxvt in particular can be
#+ troublesome) - however this code seems to work in a majority
#+ of cases.
#--------------------------------------------------------------

function get_xserver ()
{
    case $TERM in
        xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
            # Ane-Pieter Wieringa suggests the following alternative:
            #  I_AM=$(who am i)
            #  SERVER=${I_AM#*(}
            #  SERVER=${SERVER%*)}
            XSERVER=${XSERVER%%:*}
            ;;
            aterm | rxvt)
            # Find some code that works here. ...
            ;;
    esac
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) ||
       ${XSERVER} == "unix" ]]; then
          DISPLAY=":0.0"          # Display on local host.
    else
       DISPLAY=${XSERVER}:0.0     # Display on remote host.
    fi
fi

export DISPLAY

#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

ulimit -S -c 0      # Don't want coredumps.
set -o notify
set -o noclobber
set -o ignoreeof

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK        # Don't want my shell to warn me of incoming mail.

#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.

# Normal Colors
Black='\e[0;30m'
export Black
Red='\e[0;31m'
export Red
Green='\e[0;32m'
export Green
Yellow='\e[0;33m'
export Yellow
Blue='\e[0;34m'
export Blue
Purple='\e[0;35m'
export Purple
Cyan='\e[0;36m'
export Cyan
White='\e[0;37m'
export White

# Bold
BBlack='\e[1;30m'
export BBlack
BRed='\e[1;31m'
export BRed
BGreen='\e[1;32m'
export BGreen
BYellow='\e[1;33m'
export BYellow
BBlue='\e[1;34m'
export BBlue
BPurple='\e[1;35m'
export BPurple
BCyan='\e[1;36m'
export BCyan
BWhite='\e[1;37m'
export BWhite

# Background
On_Black='\e[40m'
export On_Black
On_Red='\e[41m'
export On_Red
On_Green='\e[42m'
export On_Green
On_Yellow='\e[43m'
export On_Yellow
On_Blue='\e[44m'
export On_Blue
On_Purple='\e[45m'
export On_Purple
On_Cyan='\e[46m'
export On_Cyan
On_White='\e[47m'
export On_White

NC="\e[m"	# Color Reset
export NC

ALERT=${BWhite}${On_Red} # Bold White on red background
export ALERT

#-------------------
# My Functions
#-------------------

function rc-currency {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <CountryCurrency>"; return 1; }
  echo "Querying RestCountries.eu API for ${1}"
  curl -1kLs https://restcountries.eu/rest/v2/currency/${1} |json_pp
  [[ $? -ne 0 ]] && return $?
}
export -f rc-currency

function rc-name {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <CountryName>"; return 1; }
  echo "Querying RestCountries.eu API for ${1}"
  curl -1kLs https://restcountries.eu/rest/v2/name/${1} |json_pp
  [[ $? -ne 0 ]] && return $?
}
export -f rc-name

function rc-isocc {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <CountryLtrCode>"; return 1; }
  echo "Querying RestCountries.eu API for ${1}"
  curl -1kLs https://restcountries.eu/rest/v2/alpha/${1} |json_pp
  [[ $? -ne 0 ]] && return $?
}
export -f rc-isocc

function rc-isotel {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <CountryTelCode>"; return 1; }
  echo "Querying RestCountries.eu API for ${1}"
  curl -1kLs https://restcountries.eu/rest/v2/callingcode/${1} |json_pp
  [[ $? -ne 0 ]] && return $?
}
export -f rc-isotel

function bpi1 {
  echo "Bitcoin Price Index by CEX.io API"
  curl -1kLs https://cex.io/api/last_price/BTC/USD |jq -r '.lprice' |awk '{print "1 BTC = "$1" USD"}'
  [[ $? -ne 0 ]] && return $? || return
}
export -f bpi1

function bpi2 {
  echo "Bitcoin Price Index by Blockchain.info API"
  curl -1kLs https://blockchain.info/ticker |jq -c '.["USD"]' |jq -r '.last' |awk '{print "1 BTC = "$1" USD"}'
  [[ $? -ne 0 ]] && return $? || return
}
export -f bpi2

function bpi3 {
  echo "Bitcoin Price Index by Coindesk.com API"
  curl -1kLs https://api.coindesk.com/v1/bpi/currentprice.json |jq -c '.["bpi"]' |jq -c '.["USD"]' |jq -r '.rate' |awk '{print "1 BTC = "$1" USD"}'
  [[ $? -ne 0 ]] && return $? || return
}
export -f bpi3

function ipinfo {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <ip4addr>"; return 1; }
  curl -4Ls http://ipinfo.io/${1} && printf "\n"
  [[ $? -ne 0 ]] && return $?
}
export -f ipinfo

function wttrin {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <cityname>"; return 1; }
  curl -4Ls http://wttr.in/${1}
  [[ $? -ne 0 ]] && return $?
}
export -f wttrin

#-------------------
# My Aliases
#-------------------

OS=$(uname -a |egrep -io "darwin|linux" |head -1)
export OS	# we check this in $HOME/.bash_aliases, sourced next.

#-------------------------------------------------------------
# Source local definitions (if any)
#-------------------------------------------------------------
# shellcheck source=/dev/null
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases  # --> Read $HOME/.bash_aliases, if present.
fi

# Augument $PATH
PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.rbenv/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin"
export PATH

# Perl environment https://github.com/tokuhirom/plenv
[[ $(command -v plenv) ]] && eval "$(plenv init -)"

# Ruby environment https://github.com/rbenv/rbenv
[[ $(command -v rbenv) ]] && eval "$(rbenv init -)"

# Help Midori find the vlc-plugin
MOZ_PLUGIN_PATH=/usr/lib/mozilla/plugins
export MOZ_PLUGIN_PATH

# Stick to system TCL version for now
# echo 'puts $tcl_version' |tclsh
TK_SILENCE_DEPRECATION=1
export TK_SILENCE_DEPRECATION
# alternative: brew info tcl-tk

# From gist thread https://git.io/Je8zO
# Windows 10 http://bit.ly/2PnlJmS
GPG_TTY=$(tty)
export GPG_TTY

#----------------------------------------------------------
# Remind me to install https://github.com/dylanaraps/pfetch
#----------------------------------------------------------
if [ "$(command -v pfetch)" ]; then
  pfetch
else
  echo 'TIP: install pfetch and forget issue/motd files'
fi

#-----------------------------------------------------------------
# If mcedit is present then make it my default editor or annoy me!
#-----------------------------------------------------------------
if [ "$(command -v mcedit)" ]; then
  EDITOR="$(command -pv mcedit)"
	export EDITOR
  VISUAL="$EDITOR"
	export VISUAL
  SUDO_EDITOR="$EDITOR"
	export SUDO_EDITOR
  echo 'TIP: if mcedit is NOT working with sce|sue|suvi, see https://goo.gl/vqiGQK'
  echo 'SEC: check also env_editor in man sudoers to get the full picture on sue|suvi'
fi
if [ "$(command -v select-editor)" ] && [ ! -f ~/.selected_editor ]; then
  select-editor
elif [ "$(command -v alternatives)" ]; then
  echo 'Alternative Editor'
  alternatives --display editor |grep -A2 auto
  echo '$ sudo alternatives --config editor'
elif [ "$(command -v update-alternatives)" ]; then
  echo 'Alternative Editor'
  update-alternatives --display editor |grep -A2 auto
echo '$ sudo update-alternatives --config editor'
fi

#---------------------------------------------------------------
# If a GitHub profile is present, load it (fix Homebrew on Mac)
#---------------------------------------------------------------
[[ -r .gh_profile ]] && source .gh_profile
# Add/append GHE stuff as well
[[ -r .ghe_profile ]] && source .ghe_profile
# Add/append SL stuff as well
[[ -r .sl_profile ]] && source .sl_profile

HISTFILESIZE=1024  # --> dead braincells workaround
#HISTFILESIZE=0    # --> disable history (paranoia)
