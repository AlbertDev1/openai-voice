#!/bin/bash

# Check OS and provide installation instructions
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected. Please run the following commands to install dependencies:"
    sudo apt-get update && sudo apt-get install portaudio19-dev espeak python3-pip python3-venv
    echo "Creating virtual environment for Linux..."
    python3.8 -m venv env
    source env/bin/activate
    echo "Installing Python dependencies from requirements.txt..."
    pip install --upgrade pip
    pip install -r requirements.txt
    echo "All Done ;-)"
    exit 1
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macOS detected. Checking for Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if ! brew list portaudio >/dev/null 2>&1; then
        echo "portaudio is not installed. Installing it via Homebrew..."
        brew install portaudio
    fi
    if ! brew list espeak >/dev/null 2>&1; then
        echo "espeak is not installed. Installing it via Homebrew..."
        brew install espeak
    fi
    echo "Creating virtual environment for macOS..."
    python3.8 -m venv env
    source env/bin/activate
    echo "Installing Python dependencies from requirements.txt..."
    pip install --upgrade pip
    pip install -r requirements.txt
    echo "All Done ;-)"
    exit 0
elif [[ "$OSTYPE" == "win32" ]]; then
    echo "Windows detected. Checking for Chocolatey..."
    if ! command -v choco >/dev/null 2>&1; then
        echo "Chocolatey not found. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
    fi
    echo "Installing dependencies via Chocolatey..."
    choco install -y portaudio espeak python
    echo "Creating virtual environment for Windows..."
    python3.8 -m venv env
    env\Scripts\activate.bat
    echo "Installing Python dependencies from requirements.txt..."
    pip install --upgrade pip
    pip install -r requirements.txt
    echo "All Done ;-)"
    exit 0
else
    echo "Unsupported OS detected. Please install the dependencies manually:"
    echo "portaudio: http://www.portaudio.com/download.html"
    echo "espeak: http://espeak.sourceforge.net/download.html"
    echo "Python: https://www.python.org/downloads/"
    exit 1
fi

