#!/usr/bin/env bash
set -euo pipefail

echo "::group::Updating"
sudo pacman -Syu --noconfirm
echo "::endgroup::"

WORKPATH=$GITHUB_WORKSPACE/$INPUT_PKGNAME
cd $WORKPATH

ls -la $GITHUB_WORKSPACE
ls -la $WORKPATH

echo "::group::Linking cache directory"
mkdir -p "$GITHUB_WORKSPACE"/.cache
ln -s "$GITHUB_WORKSPACE"/.cache "$HOME"/.cache
echo "::endgroup::"

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
