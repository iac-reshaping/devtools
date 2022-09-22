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
    gtkwave

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
