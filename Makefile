PROFILE = texlive.profile

.PHONY: build

build_base: Dockerfile.texlive profiles/texlive.profile
	@docker build -f Dockerfile.texlive -t maclotsen/xdp-base:slim .
	notify-send 'Makefile' 'Docker finished building Base Slim' || true

build_base_full: Dockerfile.texlive profiles/texlive-full.profile
	@docker build -f Dockerfile.texlive --build-arg profile=texlive-full.profile -t maclotsen/xdp-base:full .
	notify-send 'Makefile' 'Docker finished building Base Full' || true

build: build_base Dockerfile
	@docker build -t maclotsen/xdp:slim .
	notify-send 'Makefile' 'Docker finished building XDP Slim' || true

build_full: build_base_full Dockerfile
	@docker build --build-arg tag=full -t maclotsen/xdp:full .
	notify-send 'Makefile' 'Docker finished building XDP Full' || true

build_all: build build_full

publish: build
	@docker push maclotsen/xdp-base:slim
	@docker push maclotsen/xdp:slim

publish_full: build_full
	@docker push maclotsen/xdp-base:full
	@docker push maclotsen/xdp:full

publish_all: publish publish_full
