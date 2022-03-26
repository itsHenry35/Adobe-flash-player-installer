@echo off
::提权
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

::设置编码，使中文正常显示
chcp 65001

::确认是否安装
echo 是否安装Adobe Flash Player？要想退出安装，请直接关闭该窗口 Confirm installing Adobe Flash Player? If not, just close the window
pause

::定位到实际所在目录
cd /d %~dp0

::添加Windows7兼容性模式，使得Windows10可以正常安装ActiveX版Flash Player
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%cd%\install_flash_player_ax.exe" /t REG_SZ /d "WIN7RTM" /f

::修改hosts，去除中国不能用的限制
attrib -R %SystemRoot%\system32\drivers\etc\hosts 
@echo 127.0.0.1 flash.2144.com >>%SystemRoot%\system32\drivers\etc\hosts
@echo 127.0.0.1 www.2144.cn >>%SystemRoot%\system32\drivers\etc\hosts
@echo 127.0.0.1 fpdownload.macromedia.com >>%SystemRoot%\system32\drivers\etc\hosts
@echo 127.0.0.1 macromedia.com >>%SystemRoot%\system32\drivers\etc\hosts
@echo 127.0.0.1 fpdownload2.macromedia.com >>%SystemRoot%\system32\drivers\etc\hosts
@echo 127.0.0.1 geo2.adobe.com >>%SystemRoot%\system32\drivers\etc\hosts
ipconfig /flushdns

::正式安装flash框架
%cd%\install_flash_player_ax.exe /install
%cd%\install_flash_player.exe /install
%cd%\install_flash_player_ppapi.exe /install

::复制swf播放器到系统目录
copy flashplayer_sa.exe %HomeDrive%\

:: 设置swf播放器为默认播放器
reg add "HKCR\Applications\flashplayer_sa.exe\shell\open\command" /ve /t REG_SZ /d "\"%HomeDrive%\flashplayer_sa.exe\" \"%%1\"" /f

echo 安装完成！Success!
pause