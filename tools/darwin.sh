#!/usr/bin/env bash

set -euo pipefail

echo () {
    printf "\n%b\n" "[iac] $1"
}

IAC_FOLDER="$HOME/iac"

echo "Running brew update"
brew update

echo "Installing Verilator"
brew install verilator

echo "Installing gtkwave"
brew install --cask gtkwave

echo "Installing python..."
brew install python
python3 -m ensurepip

echo "Installing additional deps..."
brew install make cmake \
    gcc llvm \
    bison flex bc autoconf \
    qemu

echo "Installing RISC-V toolchain"
cd "${IAC_FOLDER}"
if [[ $(uname -m) == 'arm64' ]]; then
    echo "[Detected Platform] Apple Silicon"
    rm -rf riscv-gnu-toolchain.tar.gz
    curl --output riscv-gnu-toolchain.tar.gz -L https://github.com/iac-reshaping/devtools/releases/download/v1.0.0-rc.1/riscv-gnu-toolchain-2022-09-21-apple-silicon.tar.gz
    sudo tar -xzf riscv-gnu-toolchain.tar.gz --directory /opt
    export PATH="/opt/riscv/bin:$PATH"
    # shellcheck disable=SC2016
    printf '\n%s' 'export PATH="/opt/riscv/bin:$PATH"' >> ~/.zprofile
else
    echo "[Detected Platform] x86-64 Apple"
    brew install python3 gawk gnu-sed gmp mpfr libmpc isl zlib expat
    brew tap discoteq/discoteq
    brew install flock

    toolchain_git_folder="${IAC_FOLDER}/riscv-gnu-toolchain"
    
    if [ ! -d "${toolchain_git_folder}" ] 
    then
        echo "Cloning the riscv-gnu-toolchain repository... this may take a long time..."
        git clone https://github.com/riscv/riscv-gnu-toolchain "${toolchain_git_folder}" &>/dev/null
        cd "${toolchain_git_folder}"
        git checkout 2022.09.21
    else 
        echo "Updating the riscv-gnu-toolchain repository"
        cd "${toolchain_git_folder}"
        git fetch
        git checkout 2022.09.21
        git status
    fi

    sudo mkdir -p /opt/riscv
    export PATH="/opt/riscv/bin:$PATH"
    # shellcheck disable=SC2016
    printf '\n%s' 'export PATH="/opt/riscv/bin:$PATH"' >> ~/.zprofile
    ./configure --prefix=/opt/riscv --enable-multilib
    sudo make
fi

echo "riscv-gnu-toolchain installed..."
riscv64-unknown-elf-gcc --version
