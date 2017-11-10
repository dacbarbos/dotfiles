# $HOME/.bash_profile
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
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
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

#-------------------
# My Functions
#-------------------
function b2d {
  [[ $# -ne 1 ]] && echo 'Usage: b2d <01001111>' || echo $((2#"$1"))
  [[ $? -ne 0 ]] && return $? || return
}

function bpi1 {
  echo "Bitcoin Price Index by CEX.io API"
  curl -1kLs https://cex.io/api/last_price/BTC/USD |jq -r '.lprice' |awk '{print "1 BTC = "$1" USD"}'
  [[ $? -ne 0 ]] && return $? || return
}

function bpi2 {
  echo "Bitcoin Price Index by Blockchain.info API"
  curl -1kLs https://blockchain.info/ticker |jq -c '.["USD"]' |jq -r '.last' |awk '{print "1 BTC = "$1" USD"}'
  [[ $? -ne 0 ]] && return $? || return
}

function bpi3 {
  echo "Bitcoin Price Index by Coindesk.com API"
  curl -1kLs https://api.coindesk.com/v1/bpi/currentprice.json |jq -c '.["bpi"]' |jq -c '.["USD"]' |jq -r '.rate' |awk '{print "1 BTC = "$1" USD"}'
  [[ $? -ne 0 ]] && return $? || return
}

function ipinfo {
  [[ $# -ne 1 ]] && echo 'Usage: ipinfo <ip4addr>' || curl -4Ls http://ipinfo.io/"$1" && printf "\n"
  [[ $? -ne 0 ]] && return $? || return
}

function wttrin {
  [[ $# -ne 1 ]] && echo 'Usage: wttrin <cityname>' || curl -4Ls http://wttr.in/"$1"
  [[ $? -ne 0 ]] && return $? || return
}

#-------------------
# My Aliases
#-------------------

OS=$(uname -a |egrep -io "darwin|linux" |head -1)
alias ~='cd ~'
alias .='pwd'
alias ..='cd ..'
alias a='alias'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias x='exit'
alias bc='bc -l'
alias bpi='for i in {1..3}; do bpi$i; done'
alias cdn='cd $HOME/Downloads'
alias du='du -kh'
alias df='df -kh'
alias diff='colordiff'
alias lh='find . -maxdepth 1 -name ".*" -ls'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mc='mc -b'
alias pv='pv -p'
alias mkdir='mkdir -pv'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias sue='sudo -e'
alias sui='sudo -i'
alias suvi='sudo visudo'
alias sumc='sudo mc'
alias mced='mcedit -b'
alias alidep='echo alias dependencies: bleachbit, cfv, colordiff, curl, hub, jq, pv, sipcalc'
alias sumced='sudo mcedit'
alias ipcalc='sipcalc'
alias lsnc='sudo lsof -n -P -i +c 15'
alias lsuser='cut -d: -f1 /etc/passwd'
alias userlist=lsuser
alias wget='curl -kLO#'
alias which='type -a'
case "$OS" in
    Darwin)
    	alias la='ls -AlG'
    	alias ll='ls -lG'
    	alias plb='/usr/libexec/PlistBuddy'
    	alias plu='plutil'
    	alias blkid='diskutil list'
    	alias md5sum='cfv -C -t md5'
    	alias md5sum-c='cfv -f'
    	alias netstat-l='netstat -anl -f inet'
    	alias netstat6-l='netstat -anl -f inet6'
    	alias git='hub'
    	alias grep='grep --colour'
    	alias egrep='egrep --colour'
    	alias fgrep='fgrep --colour'
    	for i in 1 224 256 384 512; do alias sha"$i"sum="shasum -a $i"; done
    	for i in 1 224 256 384 512; do alias sha"$i"sum-c="shasum -a $i -c"; done
    	alias shortcuts='open https://support.apple.com/en-us/HT201236'
    	alias updatedb='pushd /usr/libexec; sudo ./locate.updatedb; popd'
    	;;
    Linux)
    	alias bb='bleachbit'
    	alias subb='sudo bleachbit'
    	alias la='ls -Al --color=auto'
    	alias ll='ls -l --color=auto'
    	alias sc='systemctl'
    	alias sce='sudo crontab -e'
    	alias scq='systemctl list-units --type=service |more'
    	alias netstat-l='ss -anp -f inet'
    	alias netstat6-l='ss -anp -f inet6'
    	alias pbcopy='xsel --clipboard --input'
    	alias pbpaste='xsel --clipboard --output'
    	alias free='free -mt'
    	alias grep='grep --color=auto'
    	alias egrep='egrep --color=auto'
    	alias fgrep='fgrep --color=auto'
    	;;
esac

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'

# Augument $PATH
#PATH=$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.rvm/bin:/opt/local/bin:/opt/local/sbin
PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.rvm/bin:/usr/local/sbin"
export PATH

# Perl environment https://github.com/tokuhirom/plenv
[[ $(command -v plenv) ]] && eval "$(plenv init -)"

# Load RVM into a shell session *as a function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Help Midori find the vlc-plugin
MOZ_PLUGIN_PATH=/usr/lib/mozilla/plugins
export MOZ_PLUGIN_PATH

#--------------------------------------------------------------
# Remind me to install https://github.com/KittyKatt/screenFetch
#--------------------------------------------------------------
if [ "$(command -v screenfetch)" ]; then
  screenfetch
else
  echo 'TIP: install screenfetch and forget issue/motd files'
fi

#-----------------------------------------------------------------
# If mcedit is present then make it my default editor or annoy me!
#-----------------------------------------------------------------
if [ $(command -v mcedit) ]; then
  export EDITOR="$(command -pv mcedit)"
  export VISUAL=$EDITOR
  export SUDO_EDITOR=$EDITOR
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

HISTFILESIZE=1024  # --> dead braincells workaround
#HISTFILESIZE=0    # --> disable history (paranoia)
