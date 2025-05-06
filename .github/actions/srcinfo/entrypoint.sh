#!/usr/bin/env bash
set -euo pipefail

WORKPATH=$GITHUB_WORKSPACE/$INPUT_PKGNAME
cd $WORKPATH
sudo chown -R builder:builder $WORKPATH/

echo "::group::Generating new .SRCINFO based on PKGBUILD"
makepkg --printsrcinfo > .SRCINFO
git diff .SRCINFO
echo "::endgroup::"
