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

## Notes on TEXMF
The image uses an alternated configuration of TEXMFDOTDIR.
The main difference is that it also allows a thinner TDS variant, which is suitable for single layered projects' directory structures (see [XDP Packaging Guidelines](https://github.com/Xerdi/texmf-packaging)).

The definition of TEXMFDOTDIR for this Docker image is:
```
TEXMFDOTDIR = .;/build//
```
and could also be achieved on your local development environment by replacing `/build` with a directory containing all your LaTeX related repositories i.e. `~/src/latex`.

Here's an example of `gitinfo-lua`s structure, which is compatible with the thinner TDS variant:
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
However, when sources are compiler-dependent, the TDS layout should be used instead.
