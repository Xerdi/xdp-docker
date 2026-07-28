#!/bin/sh
set -eu

TEXMFROOT="$(kpsewhich -var-value=TEXMFROOT)"
mkdir -p "${TEXMFROOT}/web2c/"
cp /tmp/texmf.cnf "${TEXMFROOT}/web2c/texmf.cnf"
mktexlsr

# Already included
#tlmgr install libertine

fc-cache -fv
luaotfload-tool --update

git config --global --add safe.directory /build

luatex --version
lualatex --version
tlmgr --version
