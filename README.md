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

## Internal TeX Live mirror

**Host:** `ctan.xerdi.com`

**Repository URL:** `http://ctan.xerdi.com/texlive/tlnet`

**Purpose:** Private TeX Live tlnet mirror for XDP Docker builds and AI Lab builds. It removes the dependency on external CTAN mirror selection so dev / ai-lab / xdp-docker builds stay reproducible.

**Consumers:** `dev`, `ai-lab`, `xdp-docker`.

### Usage (default — internal mirror)

`make texlive` and the `docker-publish` workflow already point at the internal mirror. Building directly with `docker build` also defaults to it:

```bash
docker build \
  -f Dockerfile.texlive \
  --build-arg TL_REPOSITORY=http://ctan.xerdi.com/texlive/tlnet \
  -t xdp-docker:latest .
```

### External fallback

To bypass the internal mirror and fall back to public CTAN mirror selection:

```bash
docker build \
  -f Dockerfile.texlive \
  --build-arg TL_REPOSITORY=https://mirror.ctan.org/systems/texlive/tlnet \
  -t xdp-docker:external-ctan .
```

The same override works for `make`:

```bash
make texlive TL_REPOSITORY=https://mirror.ctan.org/systems/texlive/tlnet
```

The `TL_REPOSITORY` value is used for both the `install-tl-unx.tar.gz` bootstrap download and `install-tl -repository`, and is pinned via `tlmgr option repository` so subsequent `tlmgr update --all` stays on the same mirror.

### Troubleshooting

Check mirror availability from the build host:

```bash
curl -I http://ctan.xerdi.com/texlive/tlnet/install-tl-unx.tar.gz
curl -I http://ctan.xerdi.com/texlive/tlnet/tlpkg/texlive.tlpdb
```

If these fail, check DNS, routing, firewall, nginx, and the mirror sync service on `ctan.xerdi.com`. If the host is unreachable from your network, use the external fallback above.

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
