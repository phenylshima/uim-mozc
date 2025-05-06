#!/usr/bin/env bash
set -euo pipefail

WORKPATH=$GITHUB_WORKSPACE/$INPUT_PKGNAME
cd $WORKPATH

echo "::group::Generating new .SRCINFO based on PKGBUILD"
ls -la
makepkg --printsrcinfo > .SRCINFO
git diff .SRCINFO
echo "::endgroup::"
