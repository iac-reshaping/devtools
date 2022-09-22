#!/usr/bin/env bash

set -euo pipefail

echo () {
    printf "\n%b\n" "[iac] $1"
}

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

echo "Adding RISC-V toolchain repo"
brew tap riscv-software-src/riscv

echo "Installing RISC-V toolchain"
brew install riscv-tools
