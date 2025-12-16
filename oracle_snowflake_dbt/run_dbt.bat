@echo off
REM Load environment variables from .env and run dbt commands
REM Usage: run_dbt.bat [dbt command]
REM Example: run_dbt.bat debug
REM Example: run_dbt.bat run

echo Loading environment variables from .env...

REM Read .env file and set environment variables
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
    set "%%a=%%b"
)

echo Environment variables loaded!
echo.
echo Running dbt %*...
echo.

REM Activate virtual environment if it exists
if exist "..\venv\Scripts\activate.bat" (
    call "..\venv\Scripts\activate.bat"
) else if exist "..\.venv\Scripts\activate.bat" (
    call "..\.venv\Scripts\activate.bat"
)

REM Run dbt command with profiles-dir set to current directory
dbt %* --profiles-dir .

echo.
echo Done!
