#!/usr/bin/env bash
set -euo pipefail

echo "::group::Updating"
sudo pacman -Syu --noconfirm
echo "::endgroup::"

WORKPATH=$GITHUB_WORKSPACE/$INPUT_PKGNAME
cd $WORKPATH

echo "::group::Updating archlinux-keyring"
sudo pacman -S --noconfirm archlinux-keyring
echo "::endgroup::"

echo "::group::Installing depends using paru"
source PKGBUILD
paru -Syu --removemake --needed --noconfirm --mflags=CFLAGS="-Wno-implicit-function-declaration" "${depends[@]}" "${makedepends[@]}" 
echo "::endgroup::"

echo "::group::Running makepkg"
makepkg
echo "::endgroup::"
