# TeX Live - Docker
![CTAN Version](https://img.shields.io/ctan/v/regulatory?label=ctan%2Fregulatory)
![CTAN Version](https://img.shields.io/ctan/v/gitinfo-lua?label=ctan%2Fgitinfo-lua)
![CTAN Version](https://img.shields.io/ctan/v/lua-placeholders?label=ctan%2Flua-placeholders)

Compiling [XDP (coming soon)](https://github.com/Xerdi/documentation-project) documents with Docker.

Using Ubuntu 22.04 as operating system having a TeX Live distribution along with some other useful tools, which are required for Xerdi's Documentation Project (XDP).

Included LaTeX packages are:
- `xdp` (WIP)
- `gitinfo-lua` ([GitHub](https://github.com/Xerdi/gitinfo-lua)|[CTAN](https://ctan.org/pkg/gitinfo-lua))
- `lua-placeholders` ([GitHub](https://github.com/Xerdi/lua-placeholders)|[CTAN](https://ctan.org/pkg/lua-placeholders))
- `regulatory` ([GitHub](https://github.com/Xerdi/regulatory)|[CTAN](https://ctan.org/pkg/regulatory))

## Prerequisites
In order to use one of the Docker images, Docker needs to be installed.
Check the [installation instructions](https://docs.docker.com/engine/install/) in order to install Docker.
Once you run Docker with an image specified, the image will get downloaded.

## Usage
The following example would be applicable for most situations:
```bash
docker run --rm -i \
       --user="$(id -u):$(id -g)" \
       -v "$PWD":/ data \
       "maclotsen/xdp" \
       "xdpmk main"
```

However, it’s still quite long and hard to remember.
Therefore, it’s wise to alias this command, so you’d end up with something like `xdpdocker xdpmk --draft main`.

*Bash version*:
```bash
#!/bin/bash
IMAGE=maclotsen/xdp:slim

exec docker run --rm -i \
  --user="$(id -u):$(id -g)" \
  -v "$PWD":/data \
  "$IMAGE" "$@"
```

*Alias version:*
```bash
BASIC_IMAGE='maclotsen/xdp-base:full'
alias texdocker='docker run --rm -i --user="$(id -u):$(id -g)" -v "$PWD":/data "$BASIC_IMAGE"'
alias lualatex='texdocker lualatex'
alias pdflatex='texdocker pdflatex'

XDP_IMAGE='maclotsen/xdp:slim'
alias xdpdocker='docker run --rm -i --user="$(id -u):$(id -g)" -v "$PWD":/data "$XDP_IMAGE"'
alias xdpmk='xdpdocker xdpmk'
```
The alias version makes it so, that when running lualatex, the executable on Docker will be used, instead of the executable that may or may not be on your system.
Another benefit of the alias version is that it can specify the Docker image for each executable separately.

