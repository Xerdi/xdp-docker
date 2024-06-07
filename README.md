# TeX Live - Docker
![CTAN Version](https://img.shields.io/ctan/v/regulatory?label=ctan%2Fregulatory)
![CTAN Version](https://img.shields.io/ctan/v/gitinfo-lua?label=ctan%2Fgitinfo-lua)
![CTAN Version](https://img.shields.io/ctan/v/lua-placeholders?label=ctan%2Flua-placeholders)

Using Ubuntu 22.04 as operating system having a TeX Live distribution along with some other useful tools, which are required for some LaTeX packages.

This Docker image is being used by the following packages:
- `gitinfo-lua` ([GitHub](https://github.com/Xerdi/gitinfo-lua)|[CTAN](https://ctan.org/pkg/gitinfo-lua))
- `lua-placeholders` ([GitHub](https://github.com/Xerdi/lua-placeholders)|[CTAN](https://ctan.org/pkg/lua-placeholders))
- `regulatory` ([GitHub](https://github.com/Xerdi/regulatory)|[CTAN](https://ctan.org/pkg/regulatory))
- `fmtcount` ([GitHub](https://github.com/Xerdi/fmtcount)|[CTAN](https://ctan.org/pkg/fmtcount))
- `luakeys` ([GitHub](https://github.com/Josef-Friedrich/luakeys)|[CTAN](https://ctan.org/pkg/luakeys))

## Prerequisites
To use one of the Docker images, Docker needs to be installed.
Check the [installation instructions](https://docs.docker.com/engine/install/) to install Docker.
Once you run Docker with an image specified, the image will get downloaded.

## Usage
The following example would be applicable for most situations:
```bash
docker run --rm -i \
       --user="$(id -u):$(id -g)" \
       -v "$PWD":/build \
       -v "$HOME/texmf":/root/texmf \
       "maclotsen/texlive:latest" \
       "pdflatex main"
```

However, it’s still quite long and hard to remember.
Therefore, it’s wise to alias this command, so you’d end up with something like `xdpdocker pdflatex main`.

```bash
#!/bin/bash
IMAGE=maclotsen/texlive:with-gf

exec docker run --rm -i \
  --user="$(id -u):$(id -g)" \
  -v "$PWD":/build \
  -v "$HOME/texmf":/root/texmf \
  "$IMAGE" "$@"
```
*~/bin/xdpdocker*

## Notes on TDS
The image uses an alternated configuration of TEXMFDOTDIR.
The main difference is that it also allows a thinner TDS variant, which is more aligned with CTANs upload directory structure.

Here's an example of `gitinfo-lua`s structure, which is compatible with the TEXMFDOTDIR structure (see [misc/texmf.cnf](misc/texmf.cnf)):
```
gitinfo-lua
├── doc
│   ├── gitinfo-lua.pdf
│   ├── gitinfo-lua.tex
├── scripts
│   ├── gitinfo-lua.lua
│   ├── gitinfo-lua-cmd.lua
│   └── gitinfo-lua-recorder.lua
└── tex
    └── gitinfo-lua.sty
```
The main difference of this approach is that Lua files don't have to be placed in under `scripts/lua`, but can directly be placed under `scripts` instead.
This also counts for TeX files. For example, `gitinfo-lua.sty` won't have to be placed in either one of the following subdirectories: `luahblatex`, `luahbtex`, `lualatex`, `latex`, `luatex` or `generic`.
The TDS approach is cumbersome for package developers that like to test their software against alternative compilers, where TEXMFDOTDIR does not.
