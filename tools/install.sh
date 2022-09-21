#!/usr/bin/env bash

set -euo pipefail

echo () {
  printf "\n%b\n" "[iac] $1"
}

IAC_FOLDER="$HOME/iac"
TOOLS_FOLDER="$IAC_FOLDER/devtools"

# Detect the OS type and install git, as well as Brew for MacOS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -qi microsoft /proc/version; then
        echo "[Detected Platform] Ubuntu on Windows"
    else
        echo "[Detected Platform] Native Linux"
    fi

    if ! git --version &>/dev/null; then
        echo "Installing git... you may have to enter your password here."
        sudo apt update
        sudo apt install -y git
    else
        echo "Git already installed... skipping"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    if ! brew --version &>/dev/null; then
        # Install Homebrew
        echo "Installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [[ $(uname -m) == 'arm64' ]]; then
            echo "[Detected Platform] Apple Silicon"
            export PATH="/opt/homebrew/bin:$PATH"

            # shellcheck disable=SC2016
            printf "\n%s" 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
        else
            echo "[Detected Platform] x86-64 Apple"
            export PATH="/usr/local/bin:$PATH"

            # shellcheck disable=SC2016
            printf "\n%s" 'eval $(/usr/local/bin/brew shellenv)' >> ~/.zprofile
        fi
    else
        echo "Homebrew already installed... skipping"
    fi

    echo "Running brew update"
    brew update

    if ! git --version &>/dev/null; then
        echo "Installing git"
        brew install git
    else
        echo "Git already installed... skipping"
    fi

    brew install coreutils
else
    echo "Error: Unrecognised OS platform detected"
    exit 1
fi

echo "Creating iac folder"
mkdir -p "$IAC_FOLDER"

if [ ! -d "$TOOLS_FOLDER" ] 
then
    echo "Cloning the iac devtools repository"
    cd "$TOOLS_FOLDER/.."
    git clone https://github.com/iac-reshaping/devtools &>/dev/null
else 
    echo "Updating the iac devtools repository"
    cd "$TOOLS_FOLDER" 
    git pull &>/dev/null
fi
