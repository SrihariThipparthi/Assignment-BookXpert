@echo off
setlocal enabledelayedexpansion

echo =========================================
echo Book Expert - Recipe Bot Setup (Windows)
echo =========================================

REM Check if Python is installed
echo.
echo 1) Checking Python version...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python not found!
    echo Please install Python 3.10+ from https://www.python.org/
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)
python --version
echo.

REM Remove old venv if it exists
if exist venv (
    echo 2) Removing existing virtual environment...
    rmdir /s /q venv
    echo Virtual environment cleaned up
    echo.
)

REM Create virtual environment
echo 3) Creating virtual environment...
python -m venv venv
if %errorlevel% neq 0 (
    echo ERROR: Failed to create virtual environment!
    echo Try running: python -m pip install --upgrade pip
    pause
    exit /b 1
)
echo Virtual environment created successfully
echo.

REM Activate virtual environment
echo 4) Activating virtual environment...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate virtual environment!
    pause
    exit /b 1
)
echo Virtual environment activated
echo.

REM Upgrade pip
echo 5) Upgrading pip...
python -m pip install --upgrade pip --quiet
if %errorlevel% neq 0 (
    echo WARNING: pip upgrade had issues, continuing anyway...
)
echo.

REM Install dependencies
echo 6) Installing dependencies (this may take 5-10 minutes)...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies!
    echo Check requirements.txt and your internet connection
    pause
    exit /b 1
)
echo.
echo =========================================
echo SUCCESS: Setup Complete!
echo =========================================
echo.
echo TO START MANUALLY IN TWO TERMINALS:
echo.
echo Terminal 1 (Backend):
echo   venv\Scripts\activate
echo   uvicorn backend.api_handler:app --host 0.0.0.0 --port 8000 --reload
echo.
echo Terminal 2 (Frontend):
echo   venv\Scripts\activate
echo   streamlit run frontend\app.py
echo.
echo ONCE RUNNING, ACCESS AT:
echo   Backend API: http://localhost:8000
echo   API Docs:    http://localhost:8000/docs
echo   Frontend UI: http://localhost:8501
echo.
echo =========================================
echo.
pause
