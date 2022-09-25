#!/usr/bin/env bash

set -euo pipefail

echo () {
    printf "\n%b\n" "[iac] $1"
}

IAC_FOLDER="$HOME/Documents/iac"

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

echo "Installing symlink to Verilator in /usr/local/share/verilator... this may require your password..."
verilator_root_path="$(verilator -getenv VERILATOR_ROOT)"
sudo mkdir -p /usr/local/share
sudo ln -sfn "${verilator_root_path}" /usr/local/share/verilator
ls -lah /usr/local/share/verilator

echo "Installing RISC-V toolchain... this may require your password..."
cd "${IAC_FOLDER}"

arch_name=$(uname -m)
rm -rf riscv-gnu-toolchain.tar.gz
curl --output riscv-gnu-toolchain.tar.gz -L "https://github.com/iac-reshaping/devtools/releases/download/v1.0.0-rc.1/riscv-gnu-toolchain-2022-09-21-Darwin-${arch_name}.tar.gz"
sudo rm -rf /opt/riscv
sudo tar -xzf riscv-gnu-toolchain.tar.gz --directory /opt
export PATH="/opt/riscv/bin:$PATH"
# shellcheck disable=SC2016
printf '\n%s' 'export PATH="/opt/riscv/bin:$PATH"' >> ~/.zprofile
rm -rf riscv-gnu-toolchain.tar.gz

echo "riscv-gnu-toolchain installed..."
riscv64-unknown-elf-gcc --version
