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

::确认是否卸载
echo 确定卸载吗？Confirm uninstalling?
pause

::恢复hosts
findstr /v /c:"www.2144.cn" /c:"flash.2144.com" /c:"fpdownload.macromedia.com" /c:"macromedia.com"  /c:"fpdownload2.macromedia.com"  /c:"geo2.adobe.com" %SystemRoot%\System32\Drivers\etc\hosts  >temphosts
if %errorlevel% EQU 0 move temphosts %SystemRoot%\System32\Drivers\etc\hosts
ipconfig /flushdns

::删除swf播放器以及对于swf文件的关联
reg DELETE HKCR\Applications\flashplayer_sa.exe /f
del %HomeDrive%\flashplayer_sa.exe\

::手动运行adobe官方flash卸载程序
echo 请在接下来的程序中，手动选择卸载！！！
cd /d %~dp0
%cd%/uninstall_flash_player.exe

echo 卸载完成！请保存好你的工作后，按任意键重启电脑以完成卸载步骤！！！！Finished! Please save your works and press any key to restart your computer!!!
pause
shutdown.exe -r -t 30