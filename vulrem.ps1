@echo off
REM Create Temp Directory
if not exist "C:\Temp" mkdir C:\Temp
 
REM Download Vulrem.zip from GCS
gsutil cp gs://vm_startup_scripts_vul_rem/Vulrem.zip C:\Temp\
 
REM Extract Vulrem.zip
powershell -Command "Expand-Archive -Path 'C:\Temp\Vulrem.zip' -DestinationPath 'C:\Temp' -Force"
 
REM Import Registry Files
regedit.exe /s C:\Temp\vulrem\CVE-2018-8339.reg
regedit.exe /s C:\Temp\vulrem\Disable_AutoPlay.reg
regedit.exe /s C:\Temp\vulrem\Disable_CachedLogonCreds.reg
regedit.exe /s C:\Temp\vulrem\Disable_LastUserName.reg
regedit.exe /s C:\Temp\vulrem\Disable_NtpServer.reg
regedit.exe /s C:\Temp\vulrem\Disable_NullSession.reg
regedit.exe /s C:\Temp\vulrem\SMBv1_Client.reg
regedit.exe /s C:\Temp\vulrem\Disable_SSL_TLS_NET_win2022.reg
regedit.exe /s C:\Temp\vulrem\Disable_Weak_Ciphers.reg
regedit.exe /s C:\Temp\vulrem\DisableAutoLogon.reg
regedit.exe /s C:\Temp\vulrem\MSORemote.reg
regedit.exe /s C:\Temp\vulrem\Disable_SMB_Signing_Require.reg
 
REM Run BAT file
start /wait C:\Temp\vulrem\Activate_QID-91462.bat
 
REM Run VBScript
cscript.exe //B C:\Temp\vulrem\Rename_Guest_Account.vbs
 
REM End of script
 
