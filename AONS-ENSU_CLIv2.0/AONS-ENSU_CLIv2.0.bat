@echo off

::This code is just for housekeeping. just leave it alone.
SETLOCAL ENABLEEXTENSIONS


::sets "parent" as the directory of AONS-ENSU.bat
SET parent=%~dp0


call :SubDependencyCheck
::checks for dependencies, prints error message if all four are not present. Doesn't stop you from continuing.


::sets the variables used in AONS-ENSU to the parameter values. can be eliminated by 
::simply changing every reference of a given variable to a flag.
:VarSet
set WD=%~1
set GI=%~2

if /I "%3" == "d" ( set ONS_N=onscripter-en-win32_dsound-20110628.zip )
if /I "%3" =="n" ( set ONS_N=onscripter-en-win32-20110628.zip )


call :SubDirAndTxt
::SubDirAndTXT enters the game directory, creates ons.cfg, a savedata folder in the game directory, 
::and changes the savedata location set in the ons.cfg file
::also creates a game.id file with the game name inside.


call :SubCopy
::Copies %ONS_N% and unzip.exe to %WD%

call :Unzip
::unzips %ONS_N% with unzip.exe


call :CleanUp
::deletes update.zip and unzip.exe


goto :end


::Subroutines (basically functions? maybe?)

::Subroutine "CleanUp"
:CleanUp
erase %ONS_N%
if exist onscripter-en-win32-20110628.zip erase onscripter-en-win32-20110628.zip
if exist onscripter-en-win32_dsound-20110628.zip erase onscripter-en-win32_dsound-20110628.zip
erase unzip.exe
goto :EOF

::Subroutine "unzip"
:Unzip
cd %WD%
unzip -o %ONS_N%
goto :EOF

::Subroutine "SubDirAndTxt"
:SubDirAndTxt
cd %WD%

mkdir savedata

cd %WD%

type nul > ons.cfg

echo save=%WD%\savedata > ons.cfg

type nul > game.id

echo %GI% > game.id
goto :EOF

::Subroutine 'SubCopy'
:SubCopy
cd %parent%

copy "%parent%\%ONS_N%" "%WD%"

copy "%parent%\unzip.exe" "%WD%"
goto :EOF


::Subroutine 'SubDependencyCheck'
:SubDependencyCheck
set /a dependencyCheckSuccess=0+0

if EXIST GPL.txt (
set /a dependencyCheckSuccess=%dependencyCheckSuccess%+1
) else echo GPL.txt not detected

if EXIST README.txt (
set /a dependencyCheckSuccess=%dependencyCheckSuccess%+1
) else echo README.txt not detected

if EXIST unzip license.txt (
set /a dependencyCheckSuccess=%dependencyCheckSuccess%+1
) else echo unzip license not detected

if EXIST unzip.exe (
set /a dependencyCheckSuccess=%dependencyCheckSuccess%+1
) else echo unzip.exe not detected

if %dependencyCheckSuccess% LSS 4 (
    echo not all dependencies are present. please refer to the list above to see what dependencies are missing, and place them in the script folder
    pause
    exit
    )
goto :EOF

:end