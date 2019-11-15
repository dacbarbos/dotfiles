@ECHO OFF
IF "%1" == "/?" GOTO howto
IF "%1" == "-?" GOTO howto
IF "%1" == "/h" GOTO howto
IF "%1" == "-h" GOTO howto
IF NOT EXIST %systemroot%\system32\doskey.exe GOTO fail

doskey alias=doskey /m
doskey blkid=label
doskey cat=type $1
doskey cdn=cd %userprofile%\Downloads
doskey chmod=icacls
doskey clear=cls
doskey cp=copy
doskey crontab=schtasks /?
doskey crontab-l=schtasks /query /?
doskey crontab-e=schtasks /change /?
doskey diff=fc $1 $2
doskey etc=cd %systemroot%\system32\drivers\etc
doskey fsck=chkdsk
doskey grep=findstr "$1" "$2" "$3"
doskey history=doskey /history
doskey id=net user %username%
doskey ifconfig=ipconfig /all
doskey ip=netsh ?
doskey kill=taskkill "$1" "$2" "$3"
doskey ll=dir /q /4
doskey ln=fsutil hardlink $1
doskey link=mklink
doskey ls=dir /w
doskey lsmod=driverquery
doskey lsof=openfiles
doskey lpr=print $1
doskey man=help $1
doskey mc=far
doskey minicom=mode
doskey mv=move "$1" "$2"
doskey myip=ipconfig /all |find /i "pref"
doskey npp=notepad++ "$1"
doskey parted=diskpart $1 $2
doskey ps=tasklist
doskey pwd=cd
doskey rm=del "$1"
doskey rdpnla0=reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /t REG_DWORD /d 0 /f
doskey rdpnla1=reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "UserAuthentication" /t REG_DWORD /d 1 /f
doskey reboot=shutdown /r /f /t 300 /c "%COMPUTERNAME% will reboot in 5 min."
doskey rsync=robocopy "$1" "$2" "$3"
doskey service=sc "$1" "$2"
doskey systemctl=wmic /?
doskey tscon=netstat -an ^|find ":3389" ^|find /i "estab"
doskey tune2fs=fsutil fsinfo $1
doskey uname=systeminfo ^|more
doskey uptime=net stats srv ^|find "since"

doskey ~=cd %userprofile%
doskey .=cd
doskey ..=cd..
doskey a=doskey /m
doskey c=cls
doskey h=doskey /history
doskey m=more
doskey w=query user
doskey x=exit

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
