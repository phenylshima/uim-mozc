#!/usr/bin/env bash
set -euo pipefail

echo "::group::Updating"
sudo pacman -Syu --noconfirm
echo "::endgroup::"

# Set path
WORKPATH=$GITHUB_WORKSPACE/$INPUT_PKGNAME
HOME=/home/builder
echo "::group::Copying files from $WORKPATH to $HOME/gh-action"
# Set path permision
cd $HOME
mkdir gh-action
cd gh-action
cp -rfv "$GITHUB_WORKSPACE"/.git ./
cp -fv "$WORKPATH"/* ./
echo "::endgroup::"

echo "::group::Linking cache directory"
sudo mkdir -p "$GITHUB_WORKSPACE"/.cache
sudo chown -R builder:builder "$GITHUB_WORKSPACE"/.cache
sudo chmod -R 775 "$GITHUB_WORKSPACE"/.cache
ln -s "$GITHUB_WORKSPACE"/.cache "$HOME"/.cache
echo "::endgroup::"

echo "::group::Updating archlinux-keyring"
sudo pacman -S --noconfirm archlinux-keyring
echo "::endgroup::"

echo "::group::PKGBUILD and .SRCINFO diff"
git diff PKGBUILD
git diff .SRCINFO
echo "::endgroup::"

echo "::group::Installing depends using paru"
source PKGBUILD
paru -Syu --removemake --needed --noconfirm --mflags=CFLAGS="-Wno-implicit-function-declaration" "${depends[@]}" "${makedepends[@]}" 
echo "::endgroup::"

echo "::group::Running makepkg"
makepkg
echo "::endgroup::"

echo "::group::Copying files from $HOME/gh-action to $WORKPATH"
sudo cp -fv PKGBUILD "$WORKPATH"/PKGBUILD
sudo cp -fv .SRCINFO "$WORKPATH"/.SRCINFO
sudo chmod -R 775 "$GITHUB_WORKSPACE"/.cache
echo "::endgroup::"
