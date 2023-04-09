#!/bin/bash

# Check OS and provide installation instructions
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected. Please run the following commands to install dependencies:"
    echo "sudo apt-get update && sudo apt-get install portaudio19-dev espeak python3-pip"
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
    if ! command -v espeak >/dev/null 2>&1; then
        echo "espeak command not found. Please install it first."
        exit 1
    fi
    echo "Installing Python dependencies from requirements.txt..."
    pip install -r requirements.txt
    exit 0
elif [[ "$OSTYPE" == "win32" ]]; then
    echo "Windows detected. Checking for Chocolatey..."
    if ! command -v choco >/dev/null 2>&1; then
        echo "Chocolatey not found. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    fi
    echo "Installing dependencies via Chocolatey..."
    choco install -y portaudio espeak python
    echo "Installing Python dependencies from requirements.txt..."
    pip install -r requirements.txt
    exit 0
else
    echo "Unsupported OS detected. Please install the dependencies manually:"
    echo "portaudio: http://www.portaudio.com/download.html"
    echo "espeak: http://espeak.sourceforge.net/download.html"
    echo "Python: https://www.python.org/downloads/"
    exit 1
fi
