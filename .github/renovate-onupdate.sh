#!/usr/bin/env bash

MOZC_ID=$(sed -nr "s/# renovate: aur-sync depName=mozc ([0-9a-fA-F]+)/\1/p" PKGBUILD)
echo "Mozc AUR commit id: $MOZC_ID"

MOZC=$(curl "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=mozc&id=$MOZC_ID")

PKGVER=$(echo "$MOZC"|sed -nr 's/^pkgver=(.*)$/\1/p')
COMMIT_REF=$(echo "$MOZC"|sed -nr "s|.*'git\+https://github.com/google/mozc.git#commit=([0-9a-fA-F]+)'.*|\1|p")

echo "Package Version: $PKGVER"
echo "Mozc commit id : $COMMIT_REF"

sed -i "s/^pkgver=.*$/pkgver=$PKGVER/" PKGBUILD
sed -i "s/^depends=\(.*'mozc>=.*'\s*'uim'.*\)$/depends=('mozc>=$PKGVER' 'uim')/" PKGBUILD
sed -i "s/^_mozcrev=\".*\"$/_mozcrev=\"$COMMIT_REF\"/" PKGBUILD
