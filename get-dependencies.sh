#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    clang   \
    cmake   \
    glslang \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano 

make-aur-package zenity-rs-bin

echo "Building OpenCMR2..."
echo "---------------------------------------------------------------"
REPO="https://github.com/pablocpas/OpenCMR2"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./OpenCMR2
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cmake -S ./OpenCMR2 -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++
cmake --build build -j$(nproc)
mv -v ./build/src/opencmr2 ./AppDir/bin
