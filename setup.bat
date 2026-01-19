@echo off
setlocal enabledelayedexpansion

echo Recipe Bot Assignment Setup

REM Create virtual environment
echo.
echo Creating virtual environment...
python -m venv venv

REM Activate virtual environment
echo.
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Upgrade pip
echo.
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install dependencies
echo.
echo Installing all dependencies...
echo    (This may take 5-10 minutes)
pip install -r requirements.txt

@REM REM Verify installation
@REM echo.
@REM echo Verifying installation...
@REM python verify_installation.py

echo.
echo Starting Backend & Frontend

REM Start FastAPI backend in new window
echo Starting FastAPI backend...
start "FastAPI Backend" cmd /k ^
uvicorn backend.api_handler:app --host 0.0.0.0 --port 8000 --reload

REM Give backend time to start
timeout /t 60 >nul

REM Start Streamlit frontend in new window
echo Starting Streamlit frontend...
start "Streamlit Frontend" cmd /k ^
streamlit run frontend\app.py

echo.
echo Setup Complete!
echo.
echo Backend   : http://localhost:8000/docs
echo Frontend : http://localhost:8501
echo.
echo.
pause
