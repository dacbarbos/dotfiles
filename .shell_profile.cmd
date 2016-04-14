@ECHO OFF
IF "%1" == "/?" GOTO howto
IF "%1" == "-?" GOTO howto
IF "%1" == "/h" GOTO howto
IF "%1" == "-h" GOTO howto
IF NOT EXIST %systemroot%\system32\doskey.exe GOTO fail

doskey alias=doskey /m
doskey blkid=label
doskey cat=type $1
doskey chmod=icacls
doskey clear=cls
doskey cp=copy
doskey crontab=schtasks
doskey diff=fc $1 $2
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
doskey minicom=mode
doskey mv=move "$1" "$2"
doskey parted=diskpart $1 $2
doskey ps=tasklist
doskey pwd=cd
doskey rm=del "$1"
doskey rsync=robocopy "$1" "$2" "$3"
doskey service=sc "$1" "$2"
doskey systemctl=wmic /?
doskey tune2fs=fsutil fsinfo $1
doskey uname=systeminfo ^|more
doskey uptime=net stats srv ^|find "since"

REM minimalist
doskey ~=cd %userprofile%
doskey .=cd
doskey ..=cd..
doskey a=doskey /m
doskey c=cls
doskey etc=cd %systemroot%\system32\drivers\etc
rem gpg4win.org
doskey gpg=%programfiles(x86)%\GPG\GnuPG\gpg2.exe
doskey h=doskey /history
doskey x=exit
REM path to binary must be known
doskey npp=notepad++ "$1"

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

GOTO :EOF
