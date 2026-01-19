#!/bin/bash

set -e 

echo ""
echo "Checking Python version..."

if command -v python3.10 &> /dev/null; then
    PYTHON_CMD="python3.10"

elif command -v py &> /dev/null && py -3.10 --version &> /dev/null; then
    PYTHON_CMD="py -3.10"

elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "Python not found!"
    exit 1
fi

PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR=$($PYTHON_CMD - <<EOF
import sys
print(sys.version_info.major)
EOF
)
PYTHON_MINOR=$($PYTHON_CMD - <<EOF
import sys
print(sys.version_info.minor)
EOF
)

echo "Found Python: $PYTHON_VERSION"

if [ "$PYTHON_MAJOR" -ne 3 ] || [ "$PYTHON_MINOR" -ne 10 ]; then
    echo "ERROR: Only Python 3.10.x is allowed"
    echo "Found: $PYTHON_MAJOR.$PYTHON_MINOR"
    exit 1
fi


PYTHON_MAJOR=$($PYTHON_CMD -c 'import sys; print(sys.version_info.major)')
PYTHON_MINOR=$($PYTHON_CMD -c 'import sys; print(sys.version_info.minor)')

if [ "$PYTHON_MAJOR" -ne 3 ] || [ "$PYTHON_MINOR" -ne 10 ]; then
    echo "ERROR: Only Python 3.10.x is allowed"
    echo "Found: $PYTHON_MAJOR.$PYTHON_MINOR"
    exit 1
fi

PYTHON_MAJOR=$($PYTHON_CMD -c 'import sys; print(sys.version_info.major)')
PYTHON_MINOR=$($PYTHON_CMD -c 'import sys; print(sys.version_info.minor)')

if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 10 ]); then
    echo "Python 3.10+ required! Found: $PYTHON_MAJOR.$PYTHON_MINOR"
    exit 1
fi

if [ -d "venv" ]; then
    echo ""
    echo "Removing existing virtual environment..."
    rm -rf venv
    echo "Cleaned up old venv"
fi

echo ""
echo "Creating virtual environment..."
if $PYTHON_CMD -m venv venv; then
    echo "Virtual environment created successfully"
else
    echo "Failed to create virtual environment"
    echo "   Try installing venv module:"
    echo "   sudo apt-get install python3.10-venv  (Ubuntu)"
    echo "   brew install python-venv  (macOS)"
    exit 1
fi

echo ""
echo "Activating virtual environment..."

if [ -f "venv/bin/activate" ]; then
    source venv/bin/activate
    echo "Virtual environment activated (Unix)"
elif [ -f "venv/Scripts/activate" ]; then
    source venv/Scripts/activate
    echo "Virtual environment activated (Windows)"
else
    echo "Failed to activate virtual environment"
    echo "   No activate script found"
    exit 1
fi


echo ""
echo "Upgrading pip..."
$PYTHON_CMD -m pip install --upgrade pip --quiet
echo "pip upgraded"

echo ""
echo "Installing dependencies (this may take 5-10 minutes)..."
if pip install -r requirements.txt; then
    echo "All dependencies installed successfully"
else
    echo "Failed to install dependencies"
    exit 1
fi

echo ""
echo "Starting Backend & Frontend..."

echo "Starting FastAPI backend..."
uvicorn backend.api_handler:app \
  --host 0.0.0.0 \
  --port 8000 \
  --reload &

BACKEND_PID=$!

echo "Waiting for backend to start..."
sleep 60

echo "Starting Streamlit frontend..."
streamlit run frontend/app.py

echo ""
echo "Shutting down backend..."
kill $BACKEND_PID
