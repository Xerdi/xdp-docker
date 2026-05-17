PROFILE = texlive.profile
# Internal Xerdi TeX Live tlnet mirror — override on the command line, e.g.
#   make build-base TL_REPOSITORY=https://mirror.ctan.org/systems/texlive/tlnet
TL_REPOSITORY ?= http://ctan.xerdi.com/texlive/tlnet

# Minimal image settings.  Override on the command line as needed, e.g.
#   make build-minimal TLNET_DIR=/srv/ctan/texlive/tlnet TL_MINIMAL_IMAGE=local/tl:dev
TL_MINIMAL_IMAGE ?= maclotsen/texlive:minimal
TLNET_DIR        ?= /srv/mirrors/texlive/current

# Shell snippet evaluated by the recipe (`$$( $(local_tlnet_rev) )`).
# Hashes the mirror's tlpdb so docker layer cache invalidates on mirror
# updates without us having to know the mirror's own versioning scheme.
local_tlnet_rev = sha256sum $(TLNET_DIR)/tlpkg/texlive.tlpdb | awk '{print substr($$1,1,12)}'

# Vendored fonts copied into the image at build time.  These targets are
# intentionally NOT prerequisites of any docker target -- once the TTF is
# on disk it won't trigger image rebuilds.  Run `make fonts` manually to
# refresh; delete the file to force a re-download.
RIGHTEOUS_DIR := misc/fonts/righteous
RIGHTEOUS_URL := https://github.com/google/fonts/raw/main/ofl/righteous

.PHONY: fonts righteous
fonts: righteous
righteous: $(RIGHTEOUS_DIR)/Righteous-Regular.ttf $(RIGHTEOUS_DIR)/OFL.txt

$(RIGHTEOUS_DIR):
	@mkdir -p $@

$(RIGHTEOUS_DIR)/Righteous-Regular.ttf: | $(RIGHTEOUS_DIR)
	@curl -fsSL "$(RIGHTEOUS_URL)/Righteous-Regular.ttf" -o $@
	@echo "Fetched $@"

$(RIGHTEOUS_DIR)/OFL.txt: | $(RIGHTEOUS_DIR)
	@curl -fsSL "$(RIGHTEOUS_URL)/OFL.txt" -o $@
	@echo "Fetched $@"

.PHONY: build-base build-google-fonts \
        build-minimal build-minimal-local-mirror build-minimal-http

build-base: Dockerfile.texlive misc/texlive.profile
	@docker build \
		-f Dockerfile.texlive \
		--build-arg profile=$(PROFILE) \
		--build-arg TL_REPOSITORY=$(TL_REPOSITORY) \
		-t maclotsen/texlive:latest .
	notify-send 'Makefile' 'Docker finished building TeX Live Latest' || true

build-google-fonts: build-base Dockerfile.google-fonts
	@docker build -f Dockerfile.google-fonts -t maclotsen/texlive:with-gf .
	notify-send 'Makefile' 'Docker finished building Google Fonts' || true

# Auto-select the build source for the minimal image: if the local TLNET
# mirror directory is present on this host, build from it (fast, offline);
# otherwise fall back to the HTTP mirror at $(TL_REPOSITORY).
ifneq ($(wildcard $(TLNET_DIR)/install-tl),)
MINIMAL_BACKEND := build-minimal-local-mirror
$(info build-minimal: using local TLNET mirror at $(TLNET_DIR))
else
MINIMAL_BACKEND := build-minimal-http
$(info build-minimal: $(TLNET_DIR) not found, falling back to HTTP repository $(TL_REPOSITORY))
endif

build-minimal: $(MINIMAL_BACKEND)

build-minimal-local-mirror: Dockerfile.texlive-minimal misc/texlive-minimal.profile | $(RIGHTEOUS_DIR)/Righteous-Regular.ttf $(RIGHTEOUS_DIR)/OFL.txt
	@TLNET_REV="$$( $(local_tlnet_rev) )"; \
	echo "Building $(TL_MINIMAL_IMAGE) from local TLNET mirror: $(TLNET_DIR)"; \
	echo "TLNET_REV=$$TLNET_REV"; \
	DOCKER_BUILDKIT=1 docker build \
		--target local-mirror \
		--build-context tlnet="$(TLNET_DIR)" \
		--build-arg TLNET_REV="$$TLNET_REV" \
		-f Dockerfile.texlive-minimal \
		-t $(TL_MINIMAL_IMAGE) \
		.
	notify-send 'Makefile' 'Docker finished building TeX Live minimal' || true

build-minimal-http: Dockerfile.texlive-minimal misc/texlive-minimal.profile | $(RIGHTEOUS_DIR)/Righteous-Regular.ttf $(RIGHTEOUS_DIR)/OFL.txt
	@TLNET_REV="$$(printf '%s' "$(TL_REPOSITORY)" | sha256sum | awk '{print $$1}')"; \
	echo "Building $(TL_MINIMAL_IMAGE) from HTTP repository: $(TL_REPOSITORY)"; \
	echo "TLNET_REV=$$TLNET_REV"; \
	DOCKER_BUILDKIT=1 docker build \
		--target http \
		--build-arg TLNET_REV="$$TLNET_REV" \
		--build-arg TL_REPOSITORY="$(TL_REPOSITORY)" \
		-f Dockerfile.texlive-minimal \
		-t $(TL_MINIMAL_IMAGE) \
		.
	notify-send 'Makefile' 'Docker finished building TeX Live minimal' || true