### man bash (init files)

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

function btc-eur {
  echo "BTC-EUR price at CEX.io"
  curl -1kLs https://cex.io/api/last_price/BTC/EUR |jq -r '.lprice' |awk '{print "1 BTC = "$1" EUR"}'
  [[ $? -ne 0 ]] && return $? || return
}
export -f btc-eur

function btc-usd {
  echo "BTC-USD price at CEX.io"
  curl -1kLs https://cex.io/api/last_price/BTC/USD |jq -r '.lprice' |awk '{print "1 BTC = "$1" USD"}'
  [[ $? -ne 0 ]] && return $? || return
}
export -f btc-usd

# See https://github.com/ivolo/disposable-email-domains
function ddom {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <example.com>"; return 1; }
  curl -4Ls https://open.kickbox.com/v1/disposable/${1} && printf "\n"
  [[ $? -ne 0 ]] && return $?
}
export -f ddom

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
    . ~/.bash_aliases
fi

# init Homebrew in Linux if present
if [ "$OS" == "Linux" ] && [ -d /home/linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# DCT https://tiny.cc/enforceDCT
export DOCKER_CONTENT_TRUST=1

# Hey QT, beware and behave
export QT_QPA_PLATFORM=wayland

# Augument $PATH
PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.rbenv/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin"
export PATH

# Java environment https://github.com/jenv/jenv
[[ $(command -v jenv) ]] && eval "$(jenv init -)"

# Perl environment https://github.com/tokuhirom/plenv
[[ $(command -v plenv) ]] && eval "$(plenv init -)"

# Ruby environment https://github.com/rbenv/rbenv
[[ $(command -v rbenv) ]] && eval "$(rbenv init -)"

# # brew info tcl-tk (use latest) is keg-only
# echo 'puts $tcl_version' |tclsh
if [ "$OS" == "Darwin" ] && [ -d /usr/local/opt/tcl-tk/bin ]; then
  export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
  export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
  export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"
  export TK_SILENCE_DEPRECATION=1
fi

# From gist thread https://git.io/Je8zO
# Windows 10 http://bit.ly/2PnlJmS
GPG_TTY=$(tty)
export GPG_TTY

# git-credential-manager
# https://git.io/JD3BE
GCM_CREDENTIAL_CACHE_OPTIONS="--timeout 3600"
export GCM_CREDENTIAL_CACHE_OPTIONS
GCM_CREDENTIAL_STORE=cache
export GCM_CREDENTIAL_STORE
GCM_GITHUB_AUTHMODES=pat
export GCM_GITHUB_AUTHMODES
GCM_INTERACTIVE=true
export GCM_INTERACTIVE

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
  alternatives --display editor |grep -A1 auto
  echo '$ sudo alternatives --config editor'
elif [ "$(command -v update-alternatives)" ]; then
  echo 'Alternative Editor'
  update-alternatives --display editor |grep -A1 auto
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
