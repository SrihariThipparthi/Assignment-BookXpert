#!/bin/bash

echo "Assignment Setup"

echo ""
echo "Creating virtual environment..."
python -m venv venv

echo ""
echo "Activating virtual environment..."
source venv/bin/activate

echo ""
echo "Upgrading pip..."
pip install --upgrade pip

echo ""
echo "Installing all dependencies..."
pip install -r requirements.txt

# echo ""
# echo "Verifying installation..."
# python verify_installation.py

echo ""
echo "Starting Backend & Frontend"

echo "Starting FastAPI backend..."
uvicorn backend.api_handler:app --host 0.0.0.0 --port 8000 --reload &

sleep 60

echo "Starting Streamlit frontend..."
streamlit run frontend/app.py

echo ""
echo "Setup Complete!"
