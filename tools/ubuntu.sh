#!/usr/bin/env bash

set -euo pipefail

echo () {
    printf "\n%b\n" "[iac] $1"
}

echo "Updating apt packages... you may have to enter your password here"
sudo apt update

echo "Installing dependencies.."
sudo apt install -y git \
    perl \
    python3 \
    python3-pip \
    gperf \
    autoconf \
    bc \
    bison \
    gcc \
    clang \
    make

sudo apt install -y \
    flex \
    build-essential \
    ca-certificates \
    ccache \
    libgoogle-perftools-dev \
    numactl \
    perl-doc \
    libfl2 \
    libfl-dev \
    zlib1g \
    zlib1g-dev \
    qemu qemu-user \
    gcc-riscv64-unknown-elf \
    gdb-multiarch \
    gtkwave \
    jq

# Install Verilator
echo "Installing Verilator"
cd /tmp
rm -rf verilator

git clone https://github.com/verilator/verilator verilator
cd verilator
git checkout v4.226
autoconf
./configure
make -j "$(nproc)"
sudo make install
cd ..
rm -rf verilator

verilator --version

# echo "Installing riscv-isa-sim"
# sudo apt install device-tree-compiler

# cd /tmp
# rm -rf riscv-isa-sim

# riscv_tools_bin_dir=$(dirname "$(which riscv64-unknown-elf-gcc)")
# riscv_tools_dir=$(dirname "${riscv_tools_bin_dir}")

# git clone https://github.com/riscv-software-src/riscv-isa-sim.git riscv-isa-sim
# cd riscv-isa-sim

# git checkout v1.1.0
# mkdir build
# cd build
# ../configure --prefix="${riscv_tools_dir}"
# make
# sudo make install

# spike --help 2>&1 | head -n 1
