### man bash (init files)
alias ~='cd ~'
alias .='pwd'
alias ..='cd ..'
alias a='alias'
alias c='clear'
alias d='disown'
alias e='egrep --color=auto'
alias f='fgrep --color=auto'
alias g='grep --color=auto'
alias h='history'
alias j='jobs -l'
alias m='more'
alias t='tail'
alias x='exit'
alias bc='bc -l'
alias du='du -kh'
alias df='df -kh'
alias diff='colordiff'
alias lh='find . -maxdepth 1 -name ".*" -ls |column -t'
alias ks='killall screen'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mc='mc -b'
alias pv='pv -p'
alias cdn='cd $HOME/Downloads'
alias cdt='cd $HOME/Desktop'
alias lzd='lazydocker'
alias lzg='lazygit'
alias sls='screen -ls'
sD() { screen -D $1; }
sr() { screen -r $1; }
alias sR='screen -R'
alias sRR='screen -RR'
sp() { screen -p $1; }
st() { screen -t $1; }
alias sx='screen -x'
alias mkdir='mkdir -pv'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias path='echo -e ${PATH//:/\\n}'
alias sue='sudo -e'
alias sui='sudo -i'
alias suvi='sudo visudo'
alias sumc='sudo mc'
alias mced='mcedit -b'
alias alidep='echo alias dependencies: cfv, colordiff, curl, dig, git, json_pp, jq, lazygit, lazydocker, pv, screen, sipcalc'
alias ipcalc='sipcalc'
alias lsnc='sudo lsof -n -P -i +c 15'
alias lsuser='cut -d: -f1 /etc/passwd'
alias userlist=lsuser
alias wget='curl -kLO#'
alias which='type -a'
# git multiuser profiles https://bit.ly/2K1sWpj
alias ggu-name='git config --global user.name'
alias ggu-email='git config --global user.email'
alias glu-name='git config --local user.name'
alias glu-email='git config --local user.email'
# git multiuser signing https://bit.ly/2ZLM69V
alias ggu-gpgprog='git config --global gpg.program'
alias ggu-gpgskey='git config --global user.signingkey'
alias glu-gpgskey='git config --local user.signingkey'
# git signing with or w/o atom https://bit.ly/37KOnGY
alias ggu-gpgsign='git config --global commit.gpgsign'
alias glu-gpgsign='git config --local commit.gpgsign'
case "$OS" in
    Darwin)
    	alias la='ls -AlG'
    	alias ll='ls -lG'
    	alias plb='/usr/libexec/PlistBuddy'
    	alias plu='plutil'
    	alias top='top -o cpu'
    	alias blkid='diskutil list'
    	alias mac='brew info m-cli'
    	alias md5sum='cfv -C -t md5'
    	alias md5sum-c='cfv -f'
    	alias netstat-l='netstat -anl -f inet'
    	alias netstat6-l='netstat -anl -f inet6'
    	alias sha256sum='shasum -a 256'
    	alias sha256sum-c='shasum -a 256 -c'
    	alias shortcuts='open https://support.apple.com/en-us/HT201236'
      RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
      export RUBY_CONFIGURE_OPTS
      NPM_HOME="$(brew --prefix node@14)/bin" # brew pin node@14
      # Should match a JIM approved version https://ibm.biz/BdfiBN
      export PATH="$NPM_HOME:$PATH"
    	;;
    Linux)
    	alias la='ls -Al --color=auto'
    	alias ll='ls -l --color=auto'
    	alias sc='systemctl'
    	alias sce='sudo crontab -e'
    	alias scq='systemctl list-units --type=service |more'
    	alias top='htop'
    	alias netstat-l='ss -anp -f inet'
    	alias netstat6-l='ss -anp -f inet6'
    	if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    	    alias pbcopy='wl-copy'
    	    alias pbpaste='wl-paste'
    	else
    	    alias pbcopy='xsel --clipboard --input'
    	    alias pbpaste='xsel --clipboard --output'
    	fi
    	alias free='free -mt'
    	# Make sense when using flatpak version on Fedora
    	if [ -f /etc/os-release ]; then
    	    osid="$(grep ^ID= /etc/os-release)" && ostr="$(echo $osid |cut -d= -f2)"
    	    if [ "$ostr" = fedora ]; then \
    	        alias atom='flatpak run io.atom.Atom' && \
    	        alias github='flatpak run io.github.shiftey.Desktop'; \
    	    fi
      fi
    	;;
esac
