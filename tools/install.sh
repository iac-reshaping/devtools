#!/usr/bin/env bash

set -euo pipefail

echo () {
    printf "\n%b\n" "[iac] $1"
}

IAC_FOLDER="$HOME/iac"
REPO_NAME="devtools"
TOOLS_FOLDER="$IAC_FOLDER/$REPO_NAME"
POST_RUN_SCRIPT=""

LOCAL_DEV="${LOCALDEV:-}"
curdir="$(pwd)"

# Detect the OS type and install git, as well as Brew for MacOS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -qi microsoft /proc/version; then
        echo "[Detected Platform] Ubuntu on Windows"
        POST_RUN_SCRIPT="./tools/ubuntu_wsl.sh"
    else
        echo "[Detected Platform] Native Linux"
        POST_RUN_SCRIPT="./tools/ubuntu.sh"
    fi

    if ! git --version &>/dev/null; then
        echo "Installing git... you may have to enter your password here."
        sudo apt update
        sudo apt install -y git
    else
        echo "Git already installed... skipping"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    POST_RUN_SCRIPT="./tools/darwin.sh"

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

if [ ! -d "$IAC_FOLDER" ]; then
    echo "Creating folder at ${IAC_FOLDER}"
    mkdir -p "$IAC_FOLDER"
else
    echo "Folder already exists at ${IAC_FOLDER}"
fi

if [ ! -d "$TOOLS_FOLDER" ] 
then
    echo "Cloning the iac devtools repository"
    cd "$IAC_FOLDER"
    git clone --recurse-submodules https://github.com/iac-reshaping/devtools "$TOOLS_FOLDER" &>/dev/null
else 
    echo "Updating the iac devtools repository"
    cd "$TOOLS_FOLDER"
    git status
    git pull
    git pull --recurse-submodules
fi

echo "Installing dependencies"
if [ -z "$LOCAL_DEV" ]; then
    "$POST_RUN_SCRIPT"
else
    echo "Local install tool development mode activated"
    cd "${curdir}"
    "$POST_RUN_SCRIPT"
fi

echo "Installation complete..."
echo "Make sure vscode is installed, then to get started run: code ${TOOLS_FOLDER}/autumn/workspace/iac-autumn.code-workspace"
echo "Make sure to mark the workspace as trusted & install the recommended extensions when prompted"
code "${TOOLS_FOLDER}/autumn/workspace/iac-autumn.code-workspace"
