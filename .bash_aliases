### man bash (init files)
alias .='pwd'
alias ..='cd ..'
alias a='alias'
alias c='clear'
alias d='disown'
alias g='grep --color=auto'
alias h='history'
alias j='jobs -l'
alias k='kubectl'
alias ks='kubectl -n kube-system'
alias kdes='kubectl describe'
alias kcf='kubectl create -f'
alias kaf='kubectl apply -f'
alias kgn='kubectl get nodes'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kd='kubectl delete'
alias kdp='kubectl delete pod'
alias kds='kubectl delete service'
alias kdd='kubectl delete deployment'
alias kdn='kubectl delete namespace'
alias m='more'
alias t='tail'
alias x='exit'
alias bc='bc -l'
alias du='du -kh'
alias df='df -kh'
alias diff='colordiff'
alias lh='ls -dl .* --group-directories-first'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mc='mc -u'
alias pv='pv -p'
alias cdd='cd $HOME/Documents'
alias cdn='cd $HOME/Downloads'
alias cdt='cd $HOME/Desktop'
alias cdm='cd $HOME/Music'
alias cdp='cd $HOME/Pictures'
alias cdv='cd $HOME/Videos'
alias eli='elinks'
alias ftp='lftp'
alias mkdir='mkdir -pv'
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias path='echo -e ${PATH//:/\\n}'
alias sue='sudo -e'
alias sui='sudo -i'
# ghr https://bit.ly/3vz8uET
alias wcl='npx wipeclean'
alias suvi='sudo visudo'
alias sumc='sudo mc -u'
alias mced='mcedit -u'
alias alidep='echo alias dependencies: cfv, colordiff, curl, dig, elinks, git, json_pp, jq, lftp, npx, pv, podman, podman-compose, sipcalc'
alias dmesg='dmesg -H'
alias docker='podman'
alias docker-compose='podman-compose'
alias dcup='docker-compose -f "$1" up -d'
alias dcdn='docker-compose -f "$1" stop'
alias dcpull='docker-compose -f "$1" pull'
alias dclogs='docker-compose -f "$1" logs -tf --tail=50'
alias dtail='docker logs -tf --tail=50 "$@"'
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
		export JAVA_HOME=$(/usr/libexec/java_home)
		export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
		# export NPM_HOME="$(brew --prefix node)/bin"
		# use Volta.sh instead of brew for NodeJS mgmt
		# brew info tcl-tk # is keg-only
		# echo 'puts $tcl_version' |tclsh
		if [ -d /usr/local/opt/tcl-tk/bin ]; then
			export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
			export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
			export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
			export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"
			export TK_SILENCE_DEPRECATION=1
		fi
		if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
			export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
		fi
		;;
	Linux)
		alias la='ls -Al --color=auto --group-directories-first'
		alias ld='ls -lD --color=auto'
		alias lf='ls -lF --color=auto |grep -v /'
		alias ll='ls -l --color=auto --group-directories-first'
		alias lz='ls -lZ --color=auto --group-directories-first'
		alias gg='gitg'
		alias gy='geany'
		alias free='free -mt'
		alias top='htop'
		alias open='xdg-open'
		alias gedit='gnome-text-editor'
		alias netstat-l='ss -anp -f inet'
		alias netstat6-l='ss -anp -f inet6'
		if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
			# Hey QT, beware and behave
			export QT_QPA_PLATFORM=wayland
			alias pbcopy='wl-copy'
			alias pbpaste='wl-paste'
		else
			alias pbcopy='xsel --clipboard --input'
			alias pbpaste='xsel --clipboard --output'
		fi
		# Make sense when using flatpak apps on Fedora
		if [ -f /etc/os-release ]; then
			osid="$(grep ^ID= /etc/os-release)" && ostr="$(echo $osid |cut -d= -f2)"
			if [ "$ostr" = fedora ]; then \
        # open https://tinyurl.com/vsc-19
				alias code='flatpak run com.visualstudio.code "$@"'; \
			fi
		fi
		;;
esac
