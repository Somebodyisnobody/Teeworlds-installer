@echo off & setlocal
mode con: lines=30 cols=130
Title Somebodyisnobody's Teeworlds installer
:bof
set "mode=checkadmin"
set "Installerversion=1.0"
rem checking for admin rights
for /f "tokens=1,2*" %%s in ('bcdedit') do set STRING=%%s
if (%STRING%)==(Zugriff) (
	set "error=Please restart with administrator permissions"
	goto fail
)
echo Installerversion: %Installerversion%
echo Script written by Somebodyisnobody
echo Github: https://github.com/Somebodyisnobody/Teeworlds-installer
echo Download the installation files at https://www.teeworlds.com
if exist "%PROGRAMFILES(X86)%" (
rem must be 64 bit OS
	if exist "%PROGRAMFILES(X86)%\Teeworlds\*.version" (
		goto Version_64_1
	)
	echo.
	echo 32 bit version: Not installed
	:Version_64_1_end
	if exist "%PROGRAMFILES%\Teeworlds\*.version" (
		goto Version_64_2
	)
	echo 64 bit version: Not installed
	echo.
	echo.
	goto Check_installed
		
) else if exist "%PROGRAMFILES%\Teeworlds\*.version" (
rem must be 32 bit OS
	goto Version_32_1
)
echo.
echo 32 bit version: Not installed
echo.
echo.
goto Check_installed

:Version_64_1
set Version1-filter=
For /f %%i in ('dir /B "%PROGRAMFILES(X86)%\Teeworlds\*.version"^|findstr "[0-9]\.[0-9]\.[0-9]"') do set "Version1-filter=%%i"
for /f "tokens=1,2,3 delims=." %%a in ('echo %Version1-filter%') do set "Version1-filter2=Installed - %%a.%%b.%%c"
echo.
echo 32 bit version: %Version1-filter2%
goto Version_64_1_end
:Version_64_2
set Version2-filter=
For /f %%i in ('dir /B "%PROGRAMFILES%\Teeworlds\*.version"^|findstr "[0-9]\.[0-9]\.[0-9]"') do set "Version2-filter=%%i"
for /f "tokens=1,2,3 delims=." %%a in ('echo %Version2-filter%') do set "Version2-filter2=Installed - %%a.%%b.%%c"
echo 64 bit version: %Version2-filter2%
echo.
echo.
goto Check_installed
:Version_32_1
set Version1-filter=
set "Version1-filter2=Not definable"
For /f %%i in ('dir /B "%PROGRAMFILES(X86)%\Teeworlds\*.version"^|findstr "[0-9]\.[0-9]\.[0-9]"') do set "Version1-filter=%%i"
for /f "tokens=1,2,3 delims=." %%a in ('echo %Version1-filter%') do set "Version1-filter2=Installed - %%a.%%b.%%c"
echo.
echo 32 bit version: %Version1-filter2%
echo.
echo.
goto Check_installed

:Check_installed
if not exist "%PROGRAMFILES(X86)%" (
	rem must be 32 bit OS
	if exist "%PROGRAMFILES%\Teeworlds" (
		rem fully installed (64 bit impossible because no 64 bit OS)
		goto installed
	)
	rem not installed, goto q1 to install
	goto q1
rem so it must be 64 bit OS
) else if exist "%PROGRAMFILES%\Teeworlds" (
	if exist "%PROGRAMFILES(X86)%\Teeworlds" (
		rem fully installed
		goto installed
	)
	rem only 64 bit installed
	set "half=64"
	set "unhalf=32"
	goto halfinstalled
) else if exist "%PROGRAMFILES(X86)%\Teeworlds" (
	rem only 32 bit installed
	set "half=32"
	set "unhalf=64"
	goto halfinstalled
)
rem not installed, automatically goto q1 to install

rem Question install
:q1
set "mode=install"
set /p q1=Do you want install Teeworlds on your PC? (y/n): 
if defined q1 set "q1=%q1:"=%" 
if defined q1 set "q1=%q1:<=%" 
if defined q1 set "q1=%q1:>=%" 
if defined q1 set "q1=%q1:|=%" 
if defined q1 set "q1=%q1:^=%" 
if defined q1 set "q1=%q1:?=%" 
if /i "%q1%" == "y" (
	goto OS_ALU
)
if /i "%q1%" == "n" (
	echo Aborted...
	pause>nul
	goto :eof
)
cls
echo Wrong value. Only "y" or "n" is allowed!
goto q1

:installed
rem already installed
echo Teeworlds is already installed.
set /p installed-q1=Do you want update (1) to a newer version or uninstall (2) Teeworlds? (1/2/Abort: 3): 
if defined installed-q1 set "installed-q1=%installed-q1:"=%" 
if defined installed-q1 set "installed-q1=%installed-q1:<=%" 
if defined installed-q1 set "installed-q1=%installed-q1:>=%" 
if defined installed-q1 set "installed-q1=%installed-q1:|=%" 
if defined installed-q1 set "installed-q1=%installed-q1:^=%" 
if defined installed-q1 set "installed-q1=%installed-q1:?=%" 
if "%installed-q1%" == "1" goto update_init
if "%installed-q1%" == "2" goto uninstall_dir
if "%installed-q1%" == "3" (
	echo Aborted...
	pause>nul
	goto :eof
)
cls
echo Wrong value. Only "1", "2" or "3" is allowed! Enter "3" to exit.
goto installed

:halfinstalled
rem already a half installed
echo The %half% bit version is already installed.
set /p halfinstalled-q1=Do you want update (1) to a newer version, install (2) the %unhalf% bit version or uninstall (3) Teeworlds? (1/2/3/Abort: 4): 
if defined halfinstalled-q1 set "halfinstalled-q1=%halfinstalled-q1:"=%" 
if defined halfinstalled-q1 set "halfinstalled-q1=%halfinstalled-q1:<=%" 
if defined halfinstalled-q1 set "halfinstalled-q1=%halfinstalled-q1:>=%" 
if defined halfinstalled-q1 set "halfinstalled-q1=%halfinstalled-q1:|=%" 
if defined halfinstalled-q1 set "halfinstalled-q1=%halfinstalled-q1:^=%" 
if defined halfinstalled-q1 set "halfinstalled-q1=%halfinstalled-q1:?=%" 
if "%halfinstalled-q1%" == "1" goto update_init
if "%halfinstalled-q1%" == "2" (
	set "mode=install"
	goto OS_ALU
)
if "%halfinstalled-q1%" == "3" goto uninstall_dir
if "%halfinstalled-q1%" == "4" (
	echo Aborted...
	pause>nul
	goto :eof
)
cls
echo Wrong value. Only "1", "2" or "3" is allowed! Enter "4" to exit.
echo.
goto halfinstalled
:OS_ALU
rem checkOS
IF EXIST "%PROGRAMFILES(X86)%" (
	set OS_ALU=x64
	goto Source_OS_Input
) ELSE IF EXIST "%PROGRAMFILES%" (
	set OS_ALU=x86
	goto Source_OS_Input
)
set "error=Could not specify the ALU"
goto fail


:Source_OS_Input


:Source
rem Teeworlds-zip Path
echo.
echo Please enter the path to the zip-file... (shift+rightclick, then "Copy as path", then rightklick on this window to paste)
set /p Source=
echo.
if defined Source set "Source=%Source:"=%" 
if defined Source set "Source=%Source:<=%" 
if defined Source set "Source=%Source:>=%" 
if defined Source set "Source=%Source:|=%" 
if defined Source set "Source=%Source:^=%" 
if defined Source set "Source=%Source:?=%" 
set Source-filter=
set Source-filter2=
rem Change path to filename
For /F %%i in ('dir /B "%Source%"') do set "Source-filter=%%~ni"
rem compare the filename with regular expression
for /f %%i in ('echo %Source-filter%^|findstr "teeworlds\-[0-9]\.[0-9]\.[0-9]\-win[64|32]"') do Set "Source-filter2=%%i"
if not defined Source-filter2 (
	cls
	echo Invalid file! Use the original.
	goto Source
)
for /f "tokens=2 delims=-" %%a in ('echo %Source-filter2%') do set "version=%%a"
for /f "tokens=3 delims=-" %%a in ('echo %Source-filter2%') do set "SOURCE_OS_ALU=%%a"
if /i "%Source_OS_ALU%" == "win64" goto Source_split
if /i "%Source_OS_ALU%" == "win32" goto Source_split
cls
set "error=Could not define Source_OS_ALU (%Source_OS_ALU%)"
goto fail
:Source_split
if "%mode%" == "update" goto update_dir
if "%mode%" == "uninstall" goto uninstall
if "%mode%" == "install" goto Dest_dir
set "error=Wrong mode"
goto fail


:Dest_dir
rem set destination
IF "%OS_ALU%" == "x64" (
	if /i "%Source_OS_ALU%" == "win64" (
		set "Dest_dir=%programfiles%"
		goto Dest_dir_end
	) ELSE IF /i "%Source_OS_ALU%" == "win32" (
		goto q2
	)
	
) ELSE IF "%OS_ALU%" == "x86" (
	if /i "%Source_OS_ALU%" == "win32" (
		set "Dest_dir=%programfiles%"
		goto Dest_dir_end
	) ELSE IF /i "%Source_OS_ALU%" == "win64" (
	
		echo You have the 64 bit of teeworlds but just a 32 bit OS...
		echo Please Download the 32 bit version at https://www.teeworlds.com
		pause>nul
		goto :eof
	)
)
set "error=Wrong ALU"
goto fail

rem 64 bit OS but 32 bit teeworlds
:q2
set /p q2=You have a 64 bit OS but just the 32 bit of teeworlds... Do you want install it force? (y/n): 
if defined q2 set "q2=%q2:"=%" 
if defined q2 set "q2=%q2:<=%" 
if defined q2 set "q2=%q2:>=%" 
if defined q2 set "q2=%q2:|=%" 
if defined q2 set "q2=%q2:^=%" 
if defined q2 set "q2=%q2:?=%" 
if /i "%q2%" == "y" (
	set "Dest_dir=%programfiles(x86)%"
	echo.
	goto Dest_dir_end
) ELSE IF /i "%q2%" == "n" (
	echo Aborted...
	pause>nul
	goto :eof
)
cls
echo Wrong value. Only "y" or "n" is allowed!
echo.
goto q2
:Dest_dir_end
if exist "%Dest_dir%\Teeworlds" (
	cls
	if /i "%Source_OS_ALU%" == "win64" (
		set "half=64"
	)
	if /i "%Source_OS_ALU%" == "win32" (
		set "half=32"
	)
	goto :echo1
)
goto unzip

:echo1
echo This version of Teeworlds (%half% bit) is already installed. Please choose the update-option to update to a newer version.
echo.
echo.
goto bof

:update_init
set "mode=update"
echo.
echo Ok i need your new Teeworlds.zip file
goto OS_ALU
:update_dir
if exist "%programfiles(x86)%\Teeworlds" (
	if exist "%programfiles%\Teeworlds" (
		goto q3.1
		rem only 32 bit installed on 64 bit os (64 because (x86)-dir )
	) else if /i "%Source_OS_ALU%" == "win64" (
		cls
		echo Can't update 64 bit Teeworlds on installed 32 bit Teeworlds. Please download the 32 bit update of Teeworlds.
		goto Source_OS_Input
	)
	set "Dest_dir=%programfiles(x86)%"
	goto update_dir_end
	rem it can be 32 or 64 bit OS (check now IS programmfiles\ there?; IS OS ALU == Source compiled OS?)
) else if exist "%programfiles%\Teeworlds" (
	if "%OS_ALU%" == "x64" (
		if /i "%Source_OS_ALU%" == "win32" (
			cls
			echo Can't update 32 bit Teeworlds on installed 64 bit Teeworlds. Please download the 64 bit update of Teeworlds.
			goto Source_OS_Input
		)
		set "Dest_dir=%programfiles%"
		goto update_dir_end
	) else if "%OS_ALU%" == "x86" (
		if /i "%Source_OS_ALU%" == "win64" (
			cls
			echo Can't update 64 bit Teeworlds on installed 32 bit Teeworlds. Please download the 32 bit update of Teeworlds.
			goto Source_OS_Input
		)
		set "Dest_dir=%programfiles%"
		goto update_dir_end
	)
)
set "error=Out of line in :update_dir. No Program Files found?"
goto fail
:q3.1
echo You have both versions of Teeworlds installed (32 and 64 bit).
:q3
set /p q3=Wich version do you want update? (32/64): 
if defined q3 set "q3=%q3:"=%" 
if defined q3 set "q3=%q3:<=%" 
if defined q3 set "q3=%q3:>=%" 
if defined q3 set "q3=%q3:|=%" 
if defined q3 set "q3=%q3:^=%" 
if defined q3 set "q3=%q3:?=%" 
if "%q3%" == "32" (
	if /i "%Source_OS_ALU%" == "win64" (
		cls
		echo Can't update 64 bit Teeworlds on installed 32 bit Teeworlds. Please download the 32 bit update of Teeworlds.
		goto Source_OS_Input
	)
	set "Dest_dir=%programfiles(x86)%"
	goto update_dir_end
) else if "%q3%" == "64" (
	if /i "%Source_OS_ALU%" == "win32" (
		cls
		echo Can't update 32 bit Teeworlds on installed 64 bit Teeworlds. Please download the 64 bit update of Teeworlds.
		goto Source_OS_Input
	)
	set "Dest_dir=%programfiles%"
	goto update_dir_end
)
cls
echo Wrong value. Only "64" or "32" is allowed!
goto q3
:update_dir_end
rem update begins
echo.
echo.|set /p =Preparing... 
if defined Dest_dir set "Dest_dir=%Dest_dir:"=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:<=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:>=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:|=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:^=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:?=%" 
rd /S /Q "%Dest_dir%\Teeworlds" >nul
if exist "%Dest_dir%\Teeworlds" (
	set "error=Can't delete the old directory. Permissions set?"
	goto fail
)
:unzip
if "%mode%" == "install" (
	echo.
	echo.|set /p =Preparing... 
)
if defined Dest_dir set "Dest_dir=%Dest_dir:"=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:<=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:>=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:|=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:^=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:?=%" 
if exist "%Source%" (
	goto checkup_end
)
set "error=Source not found..."
goto fail
:checkup_end
md "%Dest_dir%\Teeworlds" >nul
if not exist "%Dest_dir%\Teeworlds" (
	set "error=Can't create the destination directory. Permissions set?"
	goto fail
)
echo OK
echo.
if "%mode%" == "update" (
	echo.|set /p =Updating... 
) else (
	echo.|set /p =Installing... 
)
set "U=%temp%\%random%.vbs" 
>"%U%" echo     CreateObject("Shell.Application").Namespace("%Dest_dir%\Teeworlds").CopyHere CreateObject("Shell.Application").Namespace("%Source%").Items, 4 + 16 
call cscript //nologo "%U%"
del "%U%"
for /f %%i in ('dir /b "%Dest_dir%\Teeworlds\"') do set "foldername=%%i"
if not defined foldername (
	set "error=Failed to unzip the file..."
	goto fail
)
>"%Dest_dir%\Teeworlds\%version%.version" echo.
echo OK
echo.
echo.|set /p =Creating uninstaller... 
set "Uninstall=%Dest_dir%\Teeworlds\Uninstall.bat"
if defined Uninstall set "Uninstall=%Uninstall:"=%" 
if defined Uninstall set "Uninstall=%Uninstall:<=%" 
if defined Uninstall set "Uninstall=%Uninstall:>=%" 
if defined Uninstall set "Uninstall=%Uninstall:|=%" 
if defined Uninstall set "Uninstall=%Uninstall:^=%" 
if defined Uninstall set "Uninstall=%Uninstall:?=%" 
>"%Uninstall%" echo     @echo off
>>"%Uninstall%" echo     mode con: lines=15 cols=70
>>"%Uninstall%" echo     Title Somebodyisnobody's Teeworlds installer
>>"%Uninstall%" echo     for /f "tokens=1,2*" %%%%s in ('bcdedit') do set STRING=%%%%s
>>"%Uninstall%" echo     if (%%STRING%%)==(Zugriff) (
>>"%Uninstall%" echo     	set "error=Please restart with administrator permissions"
>>"%Uninstall%" echo     	goto fail
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     if "%%~f0" == "%%temp%%\Uninstall%Source_OS_ALU%.bat" (
>>"%Uninstall%" echo     	goto q1
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     if not "%%~f0" == "%%temp%%\Uninstall%Source_OS_ALU%.bat" (
>>"%Uninstall%" echo     copy /Y "%%~f0" "%%temp%%\Uninstall%Source_OS_ALU%.bat" ^>nul
>>"%Uninstall%" echo     "%%temp%%\Uninstall%Source_OS_ALU%.bat"
>>"%Uninstall%" echo     exit
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     :q1
>>"%Uninstall%" echo     echo Installerversion: %Installerversion%
>>"%Uninstall%" echo     echo Script written by Somebodyisnobody
>>"%Uninstall%" echo     echo Github: https://github.com/Somebodyisnobody/Teeworlds-installer
>>"%Uninstall%" echo     set /p q1=Are you sure that you want to uninstall Teeworlds %Source_OS_ALU%? (y/n): 
>>"%Uninstall%" echo     if defined q1 set "q1=%%q1:"=%%" 
>>"%Uninstall%" echo     if defined q1 set "q1=%%q1:<=%%" 
>>"%Uninstall%" echo     if defined q1 set "q1=%%q1:>=%%" 
>>"%Uninstall%" echo     if defined q1 set "q1=%%q1:|=%%" 
>>"%Uninstall%" echo     if defined q1 set "q1=%%q1:^=%%" 
>>"%Uninstall%" echo     if defined q1 set "q1=%%q1:?=%%" 
>>"%Uninstall%" echo     if "%%q1%%" == "y" (
>>"%Uninstall%" echo     	goto start_uninstall
>>"%Uninstall%" echo     ) else if "%%q1%%" == "n" (
>>"%Uninstall%" echo     	echo Aborted...
>>"%Uninstall%" echo     	pause^>nul
>>"%Uninstall%" echo     	goto del
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     cls
>>"%Uninstall%" echo     echo Wrong value. Only "y" or "n" is allowed!
>>"%Uninstall%" echo     goto q1
>>"%Uninstall%" echo     :start_uninstall
>>"%Uninstall%" echo     if not exist "%Dest_dir%\Teeworlds" (
>>"%Uninstall%" echo     	set "error=Destination does not exist"
>>"%Uninstall%" echo     	goto fail
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo.^|set /p =Uninstalling... 
>>"%Uninstall%" echo     rd /S /Q "%Dest_dir%\Teeworlds" ^>nul
>>"%Uninstall%" echo     if exist "%Dest_dir%\Teeworlds" (
>>"%Uninstall%" echo     	set "error=Failed to delete abandoned folders. Permissions set?"
>>"%Uninstall%" echo     	goto fail
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     set "appd=%%appdata%%"
>>"%Uninstall%" echo     if defined appd set "appd=%%appd:"=%%" 
>>"%Uninstall%" echo     if defined appd set "appd=%%appd:<=%%" 
>>"%Uninstall%" echo     if defined appd set "appd=%%appd:>=%%" 
>>"%Uninstall%" echo     if defined appd set "appd=%%appd:|=%%" 
>>"%Uninstall%" echo     if defined appd set "appd=%%appd:^=%%" 
>>"%Uninstall%" echo     if defined appd set "appd=%%appd:?=%%"
>>"%Uninstall%" echo     if exist "%%appd%%\Teeworlds" (
>>"%Uninstall%" echo     	cls
>>"%Uninstall%" echo     	goto q2
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     goto q2_end
>>"%Uninstall%" echo     :q2
>>"%Uninstall%" echo     set /p q2=Do you want to remove the preferences and settings too? (y/n): 
>>"%Uninstall%" echo     if defined q2 set "q2=%%q2:"=%%" 
>>"%Uninstall%" echo     if defined q2 set "q2=%%q2:<=%%" 
>>"%Uninstall%" echo     if defined q2 set "q2=%%q2:>=%%" 
>>"%Uninstall%" echo     if defined q2 set "q2=%%q2:|=%%" 
>>"%Uninstall%" echo     if defined q2 set "q2=%%q2:^=%%" 
>>"%Uninstall%" echo     if defined q2 set "q2=%%q2:?=%%" 
>>"%Uninstall%" echo     if /i "%%q2%%" == "y" (
>>"%Uninstall%" echo     	echo.
>>"%Uninstall%" echo     	echo.^|set /p =Removing settings... 
>>"%Uninstall%" echo     	rd /S /Q "%%appd%%\Teeworlds" ^>nul
>>"%Uninstall%" echo     	if exist "%%appd%%\Teeworlds" (
>>"%Uninstall%" echo     		set "error=Failed to delete preferences."
>>"%Uninstall%" echo     		goto fail
>>"%Uninstall%" echo     	)
>>"%Uninstall%" echo     	echo OK
>>"%Uninstall%" echo     	echo.
>>"%Uninstall%" echo     	goto q2.1
>>"%Uninstall%" echo     ) else if /i "%%q2%%" == "n" (
>>"%Uninstall%" echo     	goto q2.1
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     cls
>>"%Uninstall%" echo     echo Wrong value. Only "y" or "n" is allowed!
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     goto q2
>>"%Uninstall%" echo     :q2.1
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo.^|set /p =Uninstalling... 
>>"%Uninstall%" echo     :q2_end
>>"%Uninstall%" echo     if exist "%public%\Desktop\Teeworlds %Source_OS_ALU%.lnk" (
>>"%Uninstall%" echo     	del "%public%\Desktop\Teeworlds %Source_OS_ALU%.lnk" /Q ^>nul
>>"%Uninstall%" echo     	if exist "%public%\Desktop\Teeworlds %Source_OS_ALU%.lnk" (
>>"%Uninstall%" echo     		set "error=Failed to delete abandoned links."
>>"%Uninstall%" echo     		goto fail
>>"%Uninstall%" echo     	)
>>"%Uninstall%" echo     )
>>"%Uninstall%" echo     goto ign1
>>"%Uninstall%" echo     :fail
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo ////////////////////////////////////ERROR\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo Error: %%error%%
>>"%Uninstall%" echo     echo Installerversion: %Installerversion%
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo Need help?
>>"%Uninstall%" echo     echo Create an issue on github: https://github.com/Somebodyisnobody/Teeworlds-installer
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo ////////////////////////////////////ERROR\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
>>"%Uninstall%" echo     pause^>nul
>>"%Uninstall%" echo     goto del
>>"%Uninstall%" echo     :ign1
>>"%Uninstall%" echo     REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f ^>nul
>>"%Uninstall%" echo     echo OK
>>"%Uninstall%" echo     echo.
>>"%Uninstall%" echo     echo Uninstall successfully
>>"%Uninstall%" echo     pause^>nul
>>"%Uninstall%" echo     :del
>>"%Uninstall%" echo     del "%%~f0" ^& exit ^>nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v DisplayName /t REG_SZ /d "Teeworlds %Source_OS_ALU%" >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v UninstallString /t REG_SZ /d "\"%Dest_dir%\Teeworlds\Uninstall.bat"" >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v Publisher /t REG_SZ /d "Teeworlds Developers" >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v DisplayVersion /t REG_SZ /d %version% >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v EstimatedSize /t REG_DWORD /d 11000 >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v DisplayIcon /t REG_SZ /d "\"%Dest_dir%\Teeworlds\teeworlds.exe"" >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v InstallDir /t REG_SZ /d "\"%Dest_dir%\Teeworlds\Teeworlds\"" >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v SystemComponent /t REG_DWORD /d 0 >nul
REG ADD "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds %Source_OS_ALU%" /f /v URLInfoAbout /t REG_SZ /d https://www.teeworlds.com >nul
echo OK
echo. 
echo.|set /p =Cleaning up... 
copy "%Dest_dir%\Teeworlds\%foldername%\*" "%Dest_dir%\Teeworlds" >nul
if not exist "%Dest_dir%\Teeworlds\teeworlds.exe" (
	set "error=Failed to clean up (copy)."
	goto fail
)
move "%Dest_dir%\Teeworlds\%foldername%\data" "%Dest_dir%\Teeworlds\data" >nul
if not exist "%Dest_dir%\Teeworlds\data" (
	set "error=Failed to clean up (move)."
	goto fail
)
rd /S /Q "%Dest_dir%\Teeworlds\%foldername%\" >nul
if exist "%Dest_dir%\Teeworlds\%foldername%\" (
	set "error=Failed to clean up (delete)."
	goto fail
)
echo OK
echo.
if "%mode%" == "install" (
	echo.|set /p =Linking... 
	set "L=%temp%\%random%.vbs" 
	goto link
	:link_end
	call cscript //nologo "%L%"
	del "%L%"
	if not exist "%public%\Desktop\Teeworlds %Source_OS_ALU%.lnk" (
		set "error=Failed to create link."
		goto fail
	)
	echo OK
	echo.
	echo Installation successfully
	pause>nul
	goto :eof
) else if "%mode%" == "update" (
	echo.
	echo Update successfully
	pause>nul
	goto :eof
)
set "error=Out of line in :checkup_end. Mode = uninstall?"
goto fail

:uninstall_dir
set "mode=uninstall"
if exist "%programfiles(x86)%\Teeworlds" (
	if exist "%programfiles%\Teeworlds" (
		goto q4.1
	)
	rem only 32 bit installed on 64 bit os (64 because (x86)-dir )
	set "Dest_dir=%programfiles(x86)%"
	goto uninstall_dir_end
) else if exist "%programfiles%\Teeworlds" (
	set "Dest_dir=%programfiles%"
	goto uninstall_dir_end
)
set "error=Out of line in :uninstall_dir. No Program Files found?"
goto fail
:q4.1
echo.
echo You have both versions of Teeworlds installed (32 and 64 bit).
:q4
set /p q4=Wich version do you want uninstall? (32/64): 
if "%q4%" == "32" (
	set "Dest_dir=%programfiles(x86)%"
	goto uninstall_dir_end
) else if "%q4%" == "64" (
	set "Dest_dir=%programfiles%"
	goto uninstall_dir_end
)
cls
echo Wrong value. Only "64" or "32" is allowed!
goto q4
:uninstall_dir_end
echo.|set /p =Uninstalling... 
if defined Dest_dir set "Dest_dir=%Dest_dir:"=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:<=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:>=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:|=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:^=%" 
if defined Dest_dir set "Dest_dir=%Dest_dir:?=%" 
rd /S /Q "%Dest_dir%\Teeworlds" >nul
if exist "%Dest_dir%\Teeworlds" (
	set "error=Failed to delete abandoned folders."
	goto fail
)
set "appd=%appdata%"
if defined appd set "appd=%appd:"=%" 
if defined appd set "appd=%appd:<=%" 
if defined appd set "appd=%appd:>=%" 
if defined appd set "appd=%appd:|=%" 
if defined appd set "appd=%appd:^=%" 
if defined appd set "appd=%appd:?=%"
if exist "%appd%\Teeworlds" (
	cls
	goto q5
)
goto q5_end
:q5
set /p q5=Do you want to remove the preferences and settings too? (y/n): 
if /i "%q5%" == "y" (
	rd /S /Q "%appd%\Teeworlds" >nul
	if exist "%appd%\Teeworlds" (
		set "error=Failed to delete preferences."
		goto fail
	)
	goto q5.1
) else if /i "%q5%" == "n" (
	goto q5.1
)
cls
echo Wrong value. Only "y" or "n" is allowed!
echo.
goto q5
:q5.1
echo.
echo.|set /p =Uninstalling... 
:q5_end
For /F "skip=2 tokens=3,4" %%i in ('REG QUERY "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds win32" /v DisplayName') do set "reg_query1=%%i %%j"
if "%q4%" == "64" (
	if "%reg_query1%" == "Teeworlds win64" (
		REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds win64" /f >nul
	)
) else if "%q4%" == "32" (
	if "%reg_query1%" == "Teeworlds win32" (
		REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds win32" /f >nul
	)
) else if "%q4%" == "" (
	if "%reg_query1" == "Teeworlds win64" (
		REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds win64" /f >nul
	) else if "%reg_query1%" == "Teeworlds win32" (
		REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Teeworlds win32" /f >nul
	)
)
if "%q4%" == "64" (
	if exist "%public%\Desktop\Teeworlds win64.lnk" (
		del "%public%\Desktop\Teeworlds win64.lnk" /Q >nul
		if exist "%public%\Desktop\Teeworlds win64.lnk" (
			set "error=Failed to delete abandoned links."
			goto fail
		)
	)
) else if "%q4%" == "32" (
	if exist "%public%\Desktop\Teeworlds win32.lnk" (
		del "%public%\Desktop\Teeworlds win32.lnk" /Q >nul
		if exist "%public%\Desktop\Teeworlds win32.lnk" (
			set "error=Failed to delete abandoned links."
			goto fail
		)
	)
) else if "%q4%" == "" (
	if exist "%public%\Desktop\Teeworlds*.lnk" (
		del "%public%\Desktop\Teeworlds*.lnk" /Q >nul
		if exist "%public%\Desktop\Teeworlds*.lnk" (
			set "error=Failed to delete abandoned links."
			goto fail
		)
	)
)
echo OK
echo.
echo Uninstall successfully
pause>nul
goto :eof

:link
>"%L%" echo     Set oWS = WScript.CreateObject("WScript.Shell")
>>"%L%" echo     sLinkFile = "%public%\Desktop\Teeworlds %Source_OS_ALU%.lnk"
>>"%L%" echo     Set oLink = oWS.CreateShortcut(sLinkFile)
>>"%L%" echo     oLink.TargetPath = "%Dest_dir%\Teeworlds\teeworlds.exe"
>>"%L%" echo     oLink.Arguments = ""
>>"%L%" echo     oLink.Description = "Teeworlds installed by Somebodyisnobody's Teeworlds installer"
>>"%L%" echo     oLink.IconLocation = "%Dest_dir%\Teeworlds\teeworlds.exe, 0"
>>"%L%" echo     oLink.WindowStyle = "1"   
>>"%L%" echo     oLink.WorkingDirectory = "%Dest_dir%\Teeworlds\"
>>"%L%" echo     oLink.Save
goto link_end

rem ignore "fail"
goto ign1
:fail
echo.
echo ////////////////////////////////////ERROR\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
echo.
echo.
echo Error: %error%
echo Mode: %mode%
echo Installerversion: %Installerversion%
echo.
echo Need help?
echo Create an issue on github: https://github.com/Somebodyisnobody/Teeworlds-installer
echo.
echo ////////////////////////////////////ERROR\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
pause>nul
:ign1