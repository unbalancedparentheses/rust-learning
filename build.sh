#!/usr/bin/env bash

if [ -f /etc/os-release ]; then
        DISTRO=$(awk '/^ID=/ {print $1}' /etc/os-release | sed -e 's/ID=//g')
fi

if [ "$DISTRO" = "arch" ]; then
        pacman -Sy --noconfirm
        pacman -S --noconfirm clang curl cmake git make python2
elif [ "$DISTRO" = "debian" ]; then
        apt update
        apt install -y clang curl cmake git make python2.7
fi

git clone https://github.com/rust-lang/rust.git
cd rust || exit
cp config.toml.example config.toml
sed -i "s|#assertions = true|assertions = true|g" config.toml
sed -i "s|#debug-assertions = true|debug-assertions = true|g" config.toml
sed -i "s|#codegen-units = 0|codegen-units = 0|g" config.toml
sed -i "s|#debuginfo = true|debuginfo = true|g" config.toml
sed -i "s|#debuginfo-lines = true|debuginfo-lines = true|g" config.toml
./x.py build -i --stage 1 src/libstd
rustup toolchain link stage1 build/x86_64-unknown-linux-gnu/stage1/
rustc +stage1 -vV
