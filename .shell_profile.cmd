@ECHO OFF
IF "%1" == "/?" GOTO howto
IF "%1" == "-?" GOTO howto
IF "%1" == "/h" GOTO howto
IF "%1" == "-h" GOTO howto
IF NOT EXIST %systemroot%\system32\doskey.exe GOTO fail

doskey ~=cd %userprofile%
doskey .=cd
doskey ..=cd..
doskey a=doskey /m ^|sort
doskey c=cls
doskey h=powershell -ExecutionPolicy Bypass -Command "Add-Type -AssemblyName Microsoft.VisualBasic; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{F7}')"
doskey m=more "$1"
doskey w=query user
doskey x=exit
REM ###########################################################################
doskey alidep=echo "alias dependencies: certutil, curl, far, git, jq, netsh, notepad++, powershell, robocopy, where"
doskey blkid=label
doskey btcaddrinfo=curl -4Ls https://blockchain.info/rawaddr/$1 ^|jq del(.txs)
doskey cat=type "$1"
doskey cdn=cd %userprofile%\Downloads
doskey chmod=icacls
doskey clear=cls
doskey cp=copy "$1" "$2"
doskey crontab=schtasks /?
doskey crontab-l=schtasks /query /?
doskey crontab-e=schtasks /change /?
doskey diff=fc "$1" "$2"
doskey etc=cd %systemroot%\system32\drivers\etc
doskey edenv=rundll32 sysdm.cpl,EditEnvironmentVariables
doskey ethaddrinfo=curl -4Ls https://eth.blockscout.com/api/v2/addresses/$1 ^|jq
doskey fsck=chkdsk
doskey ggu-name=git config --global user.name
doskey ggu-email=git config --global user.email
doskey glu-name=git config --local user.name
doskey glu-email=git config --local user.email
doskey ggu-gpgprog=git config --global gpg.program
doskey ggu-gpgskey=git config --global user.signingkey
doskey glu-gpgskey=git config --local user.signingkey
doskey ggu-gpgsign=git config --global commit.gpgsign
doskey glu-gpgsign=git config --local commit.gpgsign
doskey grep=findstr "$1" "$2" "$3"
doskey host=nslookup "$1" "$2
doskey id=net user %username%
doskey ifconfig=ipconfig /all
doskey ip=netsh ?
doskey kill=taskkill "$1" "$2" "$3"
doskey lh=attrib
doskey ll=dir /q /4
doskey ln=fsutil hardlink "$1"
doskey link=mklink
doskey ls=dir /w
doskey lsmod=driverquery
doskey lsof=openfiles
doskey lpr=print "$1"
doskey man=help "$1"
doskey mc=far
doskey md5sum=certutil -hashfile "$1" md5
doskey md5sum-ps1=powershell -ExecutionPolicy Bypass -Command "Get-FileHash -Path $1 -Algorithm MD5"
doskey minicom=mode
doskey mv=move "$1" "$2"
doskey myip=ipconfig /all |find /i "pref"
doskey npp=notepad++ "$1"
doskey open=start "" "$1"
doskey parted=diskpart "$1" "$2"
REM prefer https://bit.ly/pbscoop
REM doskey pbcopy=clip
doskey ps=tasklist
doskey pwd=cd
doskey rm=del "$1"
doskey rdpnla-off=reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
doskey rdpnla-on=reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f
doskey reboot=shutdown /r /f /t 300 /c "%COMPUTERNAME% will reboot in 5 min."
doskey rsync=robocopy "$1" "$2" "$3"
doskey service=sc "$1" "$2"
doskey sha256sum=certutil -hashfile "$1" sha256
doskey sha256sum-ps1=powershell -ExecutionPolicy Bypass -Command "Get-FileHash -Path $1 -Algorithm SHA256"
doskey share=ssh -R 80:localhost:$1 nokey@localhost.run
doskey systemctl=wmic /?
doskey tscon=netstat -an ^|find ":3389" ^|find /i "estab"
doskey tune2fs=fsutil fsinfo "$1"
doskey uname=systeminfo ^|more
doskey uptime=net stats srv ^|find "since"
doskey wget=curl -kLO# "$1"
doskey which=where "$1"
doskey wpbt-off=reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v DisableWpbtExecution /t REG_DWORD /d 1 /f
doskey wpbt-on=reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v DisableWpbtExecution /t REG_DWORD /d 0 /f

GOTO :EOF

:fail
echo %ComSpec% aliases were NOT configured.
echo Errorlevel: %ERRORLEVEL%
GOTO :EOF

:howto
echo.
echo INSTALLATION
echo Copy this file into your home folder "%userprofile%" and make it persistent with the below command:
echo reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "%userprofile%\.shell_profile.cmd" /f
echo That's all. Next time you open a console session this profile script will be run automatically preloading your aliases.
echo.
echo NOTE
echo Beware of conflicts in case you're using binaries from projects like:
echo [Cygwin] https://www.cygwin.com/
echo [CoreUtils] http://gnuwin32.sourceforge.net/
echo [UnxUtils] http://unxutils.sourceforge.net/
echo [UUtils] https://github.com/uutils/coreutils/
echo [Win-Bash] http://win-bash.sourceforge.net/

GOTO :EOF
