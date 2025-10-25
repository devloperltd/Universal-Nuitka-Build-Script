@echo off
setlocal enabledelayedexpansion
title Universal Nuitka Build Script - By Laroussi Boulanouar

:: ===============================================================
:: 
::     ███╗   ██╗██╗   ██╗██╗████████╗██╗  ██╗ █████╗ 
::     ████╗  ██║██║   ██║██║╚══██╔══╝██║ ██╔╝██╔══██╗
::     ██╔██╗ ██║██║   ██║██║   ██║   █████╔╝ ███████║
::     ██║╚██╗██║██║   ██║██║   ██║   ██╔═██╗ ██╔══██║
::     ██║ ╚████║╚██████╔╝██║   ██║   ██║  ██╗██║  ██║
::     ╚═╝  ╚═══╝ ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
::                                                                           
:: ===============================================================
::  UNIVERSAL NUITKA BUILD SCRIPT  (PySide6 + SQLite/MySQL)
:: ---------------------------------------------------------------
::  Author   : Laroussi Boulanouar
::  Facebook : https://www.facebook.com/LaroussiGsm
::  Website  : https://laroussigsm.net/
::  Telegram : https://t.me/laroussigsm
:: ===============================================================

echo.
echo ===============================================================
echo            UNIVERSAL NUITKA BUILD SCRIPT
echo              (PySide6 + SQLite/MySQL)
echo ---------------------------------------------------------------
echo   Author   : Laroussi Boulanouar
echo   Facebook : https://www.facebook.com/LaroussiGsm
echo   Website  : https://laroussigsm.net/
echo   Telegram : https://t.me/laroussigsm
echo ===============================================================
echo.

:: ---------------------------
::  CHECK PYTHON VERSION
:: ---------------------------
for /f "tokens=2 delims= " %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Detected Python version: %PYTHON_VERSION%

if "%PYTHON_VERSION:~0,4%"=="3.13" (
    echo.
    echo [WARNING] Python 3.13 detected!
    echo Nuitka requires either:
    echo   1. Python 3.12 or lower
    echo   2. MSVC compiler with --msvc=latest flag
    echo.
    set /p USE_MSVC="Use MSVC compiler? (Y/n) [Requires Visual Studio Build Tools]: "

    if /i "!USE_MSVC!"=="n" (
        echo Please downgrade to Python 3.12 and try again.
        pause
        exit /b 1
    )

    set COMPILER_FLAG=--msvc=latest
) else (
    set COMPILER_FLAG=
)

:: ---------------------------
::  DEFAULT CONFIGURATION
:: ---------------------------
set MAIN_SCRIPT=main.py
set OUTPUT_DIR=dist
set ICON_FILE=app.ico
set COMPANY_NAME=YourCompany
set PRODUCT_NAME=YourApp
set FILE_VERSION=1.0.0
set PRODUCT_VERSION=1.0.0
set FILE_DESCRIPTION=Your Qt Application
set DB_ENGINE=SQLITE
set DB_DIR=db
set CONFIG_DIR=config

:: ---------------------------
::  CHECK PYTHON EXISTENCE
:: ---------------------------
where python >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found in PATH.
    pause
    exit /b 1
)

:: ---------------------------
::  ACTIVATE VENV IF PRESENT
:: ---------------------------
if exist venv\Scripts\activate (
    call venv\Scripts\activate
)

:: ---------------------------
::  ENSURE REQUIRED PACKAGES
:: ---------------------------
python -m nuitka --version >nul 2>&1
if errorlevel 1 (
    echo Installing Nuitka...
    pip install -U nuitka
)

python -c "import PySide6" >nul 2>&1
if errorlevel 1 (
    echo Installing PySide6...
    pip install -U PySide6
)

:: ---------------------------
::  CUSTOMIZATION PROMPT
:: ---------------------------
set /p CUSTOMIZE="Use default settings? (Y/n): "
if /i "%CUSTOMIZE%"=="n" goto :CUSTOM_CONFIG
goto :AFTER_CONFIG

:CUSTOM_CONFIG
    set /p MAIN_SCRIPT="Enter main script filename [main.py]: "
    if "%MAIN_SCRIPT%"=="" set MAIN_SCRIPT=main.py

    set /p OUTPUT_DIR="Enter output directory [dist]: "
    if "%OUTPUT_DIR%"=="" set OUTPUT_DIR=dist

    set /p PRODUCT_NAME="Enter product name [YourApp]: "
    if "%PRODUCT_NAME%"=="" set PRODUCT_NAME=YourApp

    echo Select database engine to bundle:
    echo   1) MySQL
    echo   2) SQLite (default)
    echo   3) Both
    set /p DB_CHOICE="Choice [2]: "

    if "%DB_CHOICE%"=="1" set DB_ENGINE=MYSQL
    if "%DB_CHOICE%"=="3" set DB_ENGINE=BOTH
goto :AFTER_CONFIG

:AFTER_CONFIG

:: ---------------------------
::  ASK USER FOR ONEFILE MODE
:: ---------------------------
set /p USE_ONEFILE="Create single EXE (--onefile)? (Y/n): "
if /i "%USE_ONEFILE%"=="y" (
    set ONEFILE_FLAG=--onefile
    echo Building as ONEFILE executable...
) else (
    set ONEFILE_FLAG=
    echo Building as STANDALONE folder...
)

:: ---------------------------
::  GENERATE CONFIG FILE
:: ---------------------------
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%"
if not exist "%CONFIG_DIR%\app.ini" (
    >"%CONFIG_DIR%\app.ini" (
        echo [app]
        echo product_name=%PRODUCT_NAME%
        echo.
        echo [database]
        if "%DB_ENGINE%"=="MYSQL" (
            echo engine=mysql
        ) else if "%DB_ENGINE%"=="BOTH" (
            echo engine=mysql
        ) else (
            echo engine=sqlite
        )
        echo mysql_host=localhost
        echo mysql_port=3306
        echo mysql_user=root
        echo mysql_password=
        echo mysql_database=%PRODUCT_NAME%
        echo sqlite_path=db/app.db
    )
)

:: ---------------------------
::  INCLUDE DATA FOLDERS
:: ---------------------------
set INCLUDE_DATA_OPTS=
for %%D in (config db qss icons json ui themes) do (
    if exist "%%D" (
        dir /b /a-d "%%D\*" | findstr /vile ".py" >nul 2>&1
        if not errorlevel 1 (
            echo Including folder: %%D
            set INCLUDE_DATA_OPTS=!INCLUDE_DATA_OPTS! --include-data-dir=%%D=%%D
        ) else (
            echo Skipping pure Python folder: %%D
        )
    )
)

:: ---------------------------
::  INSTALL MYSQL CONNECTOR (IF NEEDED)
:: ---------------------------
if "%DB_ENGINE%"=="MYSQL" goto :INSTALL_MYSQL
if "%DB_ENGINE%"=="BOTH" goto :INSTALL_MYSQL
goto :CLEAN_BUILD

:INSTALL_MYSQL
    echo Ensuring MySQL connector...
    python -c "import mysql.connector" >nul 2>&1
    if errorlevel 1 (
        pip install -U mysql-connector-python
    )
goto :CLEAN_BUILD

:: ---------------------------
::  CLEAN OLD BUILDS
:: ---------------------------
:CLEAN_BUILD
echo Cleaning previous builds...
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%" 2>nul

:: ---------------------------
::  BUILD WITH NUITKA
:: ---------------------------
echo.
echo Building %MAIN_SCRIPT% with Nuitka...
if "%COMPILER_FLAG%"=="" (
    echo Using MinGW64 compiler...
) else (
    echo Using MSVC compiler...
)

python -m nuitka ^
    --standalone ^
    %ONEFILE_FLAG% ^
    %COMPILER_FLAG% ^
    --enable-plugin=pyside6 ^
    --include-qt-plugins=platforms,imageformats ^
    %INCLUDE_DATA_OPTS% ^
    --output-dir="%OUTPUT_DIR%" ^
    --remove-output ^
    --show-progress ^
    --windows-console-mode=disable ^
    --windows-icon-from-ico="%ICON_FILE%" ^
    --company-name="%COMPANY_NAME%" ^
    --product-name="%PRODUCT_NAME%" ^
    --file-version=%FILE_VERSION% ^
    --product-version=%PRODUCT_VERSION% ^
    --file-description="%FILE_DESCRIPTION%" ^
    "%MAIN_SCRIPT%"

if errorlevel 1 (
    echo.
    echo [ERROR] Build failed.
    echo.
    if "%COMPILER_FLAG%"=="--msvc=latest" (
        echo Make sure Visual Studio Build Tools are installed.
        echo Download: https://visualstudio.microsoft.com/downloads/
    ) else (
        echo Consider using Python 3.12 or the --msvc=latest flag.
    )
    pause
    exit /b 1
)

echo.
echo Build successful!
if /i "%USE_ONEFILE%"=="y" (
    echo Output file:
    echo   %OUTPUT_DIR%\%MAIN_SCRIPT:~0,-3%.exe
) else (
    echo Executable folder:
    echo   %OUTPUT_DIR%\%MAIN_SCRIPT:~0,-3%.dist\
)
echo.

set /p OPENFOLDER="Open output folder? (Y/n): "
if /i not "%OPENFOLDER%"=="n" (
    if /i "%USE_ONEFILE%"=="y" (
        explorer "%OUTPUT_DIR%"
    ) else (
        explorer "%OUTPUT_DIR%\%MAIN_SCRIPT:~0,-3%.dist"
    )
)

pause
exit /b 0