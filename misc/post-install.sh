#!/bin/sh
set -eu

TEXMFROOT="$(kpsewhich -var-value=TEXMFROOT)"
cp /tmp/texmf.cnf "${TEXMFROOT}/web2c/texmf.cnf"
mktexlsr

tlmgr install libertine

fc-cache -fv
luaotfload-tool --update

git config --global --add safe.directory /build

luatex --version
lualatex --version
tlmgr --version
