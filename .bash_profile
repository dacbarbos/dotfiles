### man bash (init files)

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

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
    case "$TERM" in
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
export Black='\e[0;30m'
export Red='\e[0;31m'
export Green='\e[0;32m'
export Yellow='\e[0;33m'
export Blue='\e[0;34m'
export Purple='\e[0;35m'
export Cyan='\e[0;36m'
export White='\e[0;37m'

# Bold
export BBlack='\e[1;30m'
export BRed='\e[1;31m'
export BGreen='\e[1;32m'
export BYellow='\e[1;33m'
export BBlue='\e[1;34m'
export BPurple='\e[1;35m'
export BCyan='\e[1;36m'
export BWhite='\e[1;37m'

# Background
export On_Black='\e[40m'
export On_Red='\e[41m'
export On_Green='\e[42m'
export On_Yellow='\e[43m'
export On_Blue='\e[44m'
export On_Purple='\e[45m'
export On_Cyan='\e[46m'
export On_White='\e[47m'

export NC="\e[m"	# Color Reset

export ALERT=${BWhite}${On_Red} # Bold White on red background

#-------------------
# My Functions
#-------------------

function cnj {
  echo "Chuck Norris public API called. Awaiting joke..."
  curl -1kLs https://api.chucknorris.io/jokes/random |jq -r '.value'
}
export -f cnj

function btcaddrinfo {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <bitcoin_address>"; return 1; }
  echo "Blockchain public API called. Awaiting results..."
  curl -4Ls https://blockchain.info/rawaddr/${1} |jq 'del(.txs)' && printf "\n"
}
export -f btcaddrinfo

function ethaddrinfo {

  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <ethereum_address>"; return 1; }
  echo "Blockscout public API called. Awaiting results..."
  curl -4Ls https://eth.blockscout.com/api/v2/addresses/${1} |jq
}
export -f ethaddrinfo

function btc-eur {
  echo "CEX.io public API"
  curl -1kLs https://cex.io/api/last_price/BTC/EUR |jq -r '.lprice' |awk '{print "1 BTC = "$1" EUR"}'
}
export -f btc-eur

function eth-eur {
  echo "CEX.io public API"
  curl -1kLs https://cex.io/api/last_price/ETH/EUR |jq -r '.lprice' |awk '{print "1 ETH = "$1" EUR"}'
}
export -f eth-eur

function define {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <word>"; return 1; }
  curl dict://dict.org/define:${1}
}
export -f define

# open https://github.com/ivolo/disposable-email-domains
function demdom {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <example.com>"; return 1; }
  curl -4Ls https://open.kickbox.com/v1/disposable/${1} && printf "\n"
}
export -f demdom

function ipinfo {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <ip4addr>"; return 1; }
  curl -4Ls http://ipinfo.io/${1} && printf "\n"
}
export -f ipinfo

function wttrin {
  [[ $# -ne 1 ]] && { echo "Usage: ${FUNCNAME} <cityname>"; return 1; }
  curl -4Ls http://wttr.in/${1}
}
export -f wttrin

#-------------------
# My Aliases
#-------------------

# we check this in $HOME/.bash_aliases, sourced next.
OS=$(uname -a |egrep -io "darwin|linux" |head -1) && export OS

#-------------------------------------------------------------
# Source local definitions (if any)
#-------------------------------------------------------------
# shellcheck source=/dev/null
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# GoLang prepare a temporary var to augment $PATH later on..
[[ $(command -v go) ]] && GOBIN="$(go env GOPATH)/bin" || GOBIN=""

# init Homebrew in Linux if present
if [ "$OS" == "Linux" ] && [ -d /home/linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# disable Homebrew hints (man brew)
export HOMEBREW_NO_ENV_HINTS=1

# Proactively set ENV for Cargo
# open https://bit.ly/cargo-home
export CARGO_HOME="$HOME/.cargo"

# open https://tiny.cc/enforceDCT
export DOCKER_CONTENT_TRUST=1

# Proactively set ENV for Jenv
export JENV_HOME="$HOME/.jenv"

# Avoid NodeJS npm issues, use volta.sh
# open https://tinyurl.com/npm-i-g
if [ -d "$HOME/.npm-global" ]; then
    export NPM_CONFIG_PREFIX=~/.npm-global
else
    mkdir "$HOME/.npm-global"
    export NPM_CONFIG_PREFIX=~/.npm-global
fi

# Proactively set ENV for PyENV
export PYENV_ROOT="$HOME/.pyenv"
# NB: Forget PyENV. Just use UV!
# open https://youtu.be/k0F9YaAbNwo

# Proactively set ENV for RBenv
export RBENV_ROOT="$HOME/.rbenv"

# Proactively set ENV for Volta.sh
# open https://docs.volta.sh/guide/getting-started
# beware of post "brew upgrade" broken links issue
# https://github.com/volta-cli/volta/issues/1053
export VOLTA_HOME="$HOME/.volta"

# Augument $PATH
export PATH="$PATH:$GOBIN:$HOME/.local/bin:$HOME/bin:\
$CARGO_HOME/bin:$JENV_HOME/bin:$NPM_CONFIG_PREFIX/bin:\
$PYENV_ROOT/bin:$RBENV_ROOT/bin:$VOLTA_HOME/bin:\
/usr/local/sbin:/opt/local/bin:/opt/local/sbin"

# Atuin shell plugin
# open https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
[[ -d "$HOME/.config/atuin" ]] && export ATUIN_CONFIG_DIR="$HOME/.config/atuin"
[[ $(command -v atuin) ]] && eval "$(atuin init bash)"

# Go env/rt mgmt https://github.com/syndbg/goenv
[[ $(command -v goenv) ]] && eval "$(goenv init -)"

# Java env/rt mgmt https://github.com/jenv/jenv
[[ $(command -v jenv) ]] && eval "$(jenv init -)"

# Perl env/rt mgmt https://github.com/tokuhirom/plenv
[[ $(command -v plenv) ]] && eval "$(plenv init -)"

# Python env/rt mgmt https://github.com/pyenv/pyenv
[[ $(command -v pyenv) ]] && eval "$(pyenv init -)"

# Ruby env/rt mgmt https://github.com/rbenv/rbenv
[[ $(command -v rbenv) ]] && eval "$(rbenv init -)"

# Gist thread https://git.io/Je8zO
# Windows 10 http://bit.ly/2PnlJmS
GPG_TTY="$(tty)" && export GPG_TTY

# git-credential-manager
export GCM_CREDENTIAL_CACHE_OPTIONS="--timeout 3600"
export GCM_CREDENTIAL_STORE=cache
export GCM_GITHUB_AUTHMODES=pat
export GCM_INTERACTIVE=true

#----------------------------------------------------------
# Remind me to install https://crates.io/crates/macchina
#----------------------------------------------------------
if [ "$(command -v macchina)" ]; then
	macchina
else
	echo 'TIP: install macchina and forget issue/motd files'
  echo 'HOW: sudo apt/dnf -y install rustup'
  echo 'APT: rustup default stable'
  echo 'DNF: rustup-init'
  echo '-->: cargo install macchina'
  echo 'APT: sudo apt -y install pkg-config'
  echo 'DNF: sudo dnf -y install pkgconf-pkg-config'
  echo '-->: cargo install cargo-binstaller'
  echo '-->: cargo install cargo-update'
  echo 'TUI: cargo install cargo-seek'
fi

#-----------------------------------------------------------------
# If mcedit is present then make it my default editor or annoy me!
#-----------------------------------------------------------------
if [ "$(command -v mcedit)" ]; then
	EDITOR="$(command -pv mcedit)" && export EDITOR
	export VISUAL="$EDITOR"
	export SUDO_EDITOR="$EDITOR"
	echo 'TIP: in case mcedit is NOT working with sue|suvi, see https://goo.gl/vqiGQK'
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

#-------------------------------------------------------
# Source dot_profiles when present (fix Homebrew on Mac)
#-------------------------------------------------------
[[ -r .ai_profile ]] && source .ai_profile
[[ -r .gh_profile ]] && source .gh_profile
[[ -r .ghe_profile ]] && source .ghe_profile
[[ -r .gl_profile ]] && source .gl_profile
[[ -r .sl_profile ]] && source .sl_profile

HISTFILESIZE=1024  # --> dead braincells workaround
#HISTFILESIZE=0    # --> disable history (paranoia)
