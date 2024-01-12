@echo off

REM Check if Python is installed using winget
winget list -e | findstr /i /C:"Python" >nul
if %errorlevel% neq 0 (
    echo Python is not installed. Installing Python...
    winget install --id Python.Python -e
)

REM Set up a virtual environment if it doesn't exist
if not exist venv\Scripts\activate.bat (
    echo Setting up virtual environment...
    python -m venv venv
)

REM Activate the virtual environment
call venv\Scripts\activate.bat

REM Install requirements
python.exe -m pip --disable-pip-version-check install pyperclip

:LOOP
REM Run the script
python random_artist.py

REM Ask the user if they want to run the script again
choice /c yn /m "Copied to clipboard! Run again?"
if %errorlevel% equ 1 goto :LOOP
if %errorlevel% equ 2 exit

REM Close the command prompt after the script finishes
exit
