# Setup Troubleshooting Guide

## Error: `venv/bin/activate: No such file or directory`

###  Problem
```bash
./setup.sh: line 11: venv/bin/activate: No such file or directory
```

### Solutions

#### **Solution 1: Check Python Installation (MOST COMMON)**

The virtual environment creation failed because Python is not properly installed or not in PATH.

**On macOS:**
```bash
# Check if Python 3.10+ is installed
python3 --version

# If not installed, install with Homebrew
brew install python@3.10
```

**On Ubuntu/Debian:**
```bash
# Check if Python 3.10+ is installed
python3 --version

# If not installed, install it
sudo apt-get update
sudo apt-get install python3.10 python3.10-venv

# Verify installation
python3.10 --version
```

**On Other Linux Distributions:**
```bash
# Use your package manager
# For Fedora:
sudo dnf install python3.10 python3.10-devel
```

---

#### **Solution 2: Verify Python is in PATH**

```bash
# Test if Python is accessible
which python3

# Expected output: /usr/bin/python3 (or similar)

# If nothing appears, Python is not in PATH
# Reinstall Python and ensure "Add to PATH" is checked
```

---

#### **Solution 3: Install venv Module**

Sometimes Python is installed but the venv module is missing.

**On Ubuntu/Debian:**
```bash
sudo apt-get install python3-venv python3.10-venv
```

**On Fedora/RHEL:**
```bash
sudo dnf install python3-venv
```

**On macOS (Homebrew):**
```bash
brew install python-venv@3.10
```

---

#### **Solution 4: Run Setup Script with Diagnostics**

```bash
# Add these lines to diagnose the issue
which python3
python3 --version
python3 -m venv --help  # Check if venv module works

# Then try setup again
chmod +x setup.sh
./setup.sh
```

---

#### **Solution 5: Manual Setup (If Script Fails)**

Follow these steps manually:

```bash
# 1. Create virtual environment manually
python3 -m venv venv

# 2. Activate it
source venv/bin/activate

# 3. Upgrade pip
pip install --upgrade pip

# 4. Install dependencies
pip install -r requirements.txt

# 5. You're done! Now start the services:
# Terminal 1:
uvicorn backend.api_handler:app --host 0.0.0.0 --port 8000 --reload

# Terminal 2:
streamlit run frontend/app.py
```

---

## Other Common Errors

###  `command not found: python`

**Cause:** Python is not installed or not in PATH

**Fix:**
```bash
# Use python3 explicitly
python3 -m venv venv
source venv/bin/activate
```

---

###  `ModuleNotFoundError: No module named 'venv'`

**Cause:** venv module not installed with Python

**Fix (Ubuntu/Debian):**
```bash
sudo apt-get install python3-venv
python3 -m venv venv
source venv/bin/activate
```

---

###  `permission denied: ./setup.sh`

**Cause:** Script doesn't have execute permission

**Fix:**
```bash
chmod +x setup.sh
./setup.sh
```

---

###  `pip: command not found` after activating venv

**Cause:** Virtual environment not properly activated

**Fix:**
```bash
# Deactivate current venv
deactivate

# Remove venv
rm -rf venv

# Create new venv
python3 -m venv venv

# Activate properly
source venv/bin/activate

# Verify pip works
pip --version
```

---

###  `ERROR: Could not find a version that satisfies the requirement`

**Cause:** Some dependency version is incompatible with your Python version

**Fix:**
```bash
# Upgrade pip
pip install --upgrade pip

# Try installing again
pip install -r requirements.txt

# If still fails, try with Python 3.11 instead
python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

###  Port 8000 or 8501 already in use

**On macOS/Linux:**
```bash
# Find process using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or change the port in setup
uvicorn backend.api_handler:app --port 8002
```

**On Windows (PowerShell):**
```powershell
# Find process using port 8000
netstat -ano | findstr :8000

# Kill the process
taskkill /PID <PID> /F
```

---

## Windows-Specific Issues

###  `'python' is not recognized as an internal or external command`

**Cause:** Python not in system PATH

**Fix:**
1. Uninstall Python completely
2. Reinstall from https://www.python.org/
3. **IMPORTANT:** Check "Add Python to PATH" during installation
4. Restart your terminal
5. Verify: `python --version`

---

###  Script runs but venv not found

**Check:**
```batch
dir venv\Scripts\activate.bat

REM If it doesn't exist, try:
python -m venv venv

REM Manually activate:
venv\Scripts\activate.bat
```

---

###  `The system cannot find the path specified`

**Cause:** Working directory issue

**Fix:**
```batch
# Make sure you're in the project root
cd C:\Users\YourUsername\Desktop\book-expert-assignment

# Then run:
setup.bat
```

---

## Step-by-Step Verification

### After setup completes, verify everything works:

```bash
# 1. Check virtual environment is active (should show (venv) prefix)
source venv/bin/activate

# 2. Check Python version
python --version

# 3. Check pip
pip --version

# 4. Check key packages installed
python -c "import torch; print(f'PyTorch: {torch.__version__}')"
python -c "import transformers; print(f'Transformers: {transformers.__version__}')"
python -c "import fastapi; print(f'FastAPI: {fastapi.__version__}')"

# 5. Start services
# Terminal 1:
uvicorn backend.api_handler:app --host 0.0.0.0 --port 8000 --reload

# Terminal 2:
streamlit run frontend/app.py
```

---

## Quick Checklist

- [ ] Python 3.10+ installed (`python3 --version`)
- [ ] venv module available (`python3 -m venv --help`)
- [ ] venv created successfully (folder exists: `venv/`)
- [ ] Can activate venv (`source venv/bin/activate`)
- [ ] pip working in venv (`pip --version`)
- [ ] Dependencies installed (`pip list | grep fastapi`)
- [ ] Port 8000 available (`lsof -i :8000` shows nothing)
- [ ] Port 8501 available (`lsof -i :8501` shows nothing)

---

## Need More Help?

If you're still stuck:

1. **Check the exact error message** - Look for the red error text
2. **Show full terminal output** - Copy everything from start to error
3. **Verify Python version** - `python3 --version` must be 3.10+
4. **Try manual steps** - Follow "Solution 5" above
5. **Check internet connection** - pip needs to download ~1GB of packages

---

**Remember:** The improved setup.sh and setup.bat now include automatic error checking and helpful messages! 🎉
