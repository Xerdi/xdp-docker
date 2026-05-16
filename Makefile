PROFILE = texlive.profile
# Internal Xerdi TeX Live tlnet mirror — override on the command line, e.g.
#   make texlive TL_REPOSITORY=https://mirror.ctan.org/systems/texlive/tlnet
TL_REPOSITORY ?= http://ctan.xerdi.com/texlive/tlnet

texlive: Dockerfile.texlive misc/texlive.profile
	@docker build \
		-f Dockerfile.texlive \
		--build-arg profile=$(PROFILE) \
		--build-arg TL_REPOSITORY=$(TL_REPOSITORY) \
		-t maclotsen/texlive:latest .
	notify-send 'Makefile' 'Docker finished building TeX Live Latest' || true

with_gf: texlive Dockerfile.google-fonts
	@docker build -f Dockerfile.google-fonts -t maclotsen/texlive:with-gf .
	notify-send 'Makefile' 'Docker finished building Google Fonts' || true

tl_2022:
	@docker build -f Dockerfile.tl-2022 \
		--build-arg TL_REPOSITORY=$(TL_REPOSITORY) \
		-t maclotsen/texlive:2022 .
	notify-send 'Makefile' 'Docker finished building TL 2022' || true

publish: texlive with_gf tl_2022
	@docker push maclotsen/texlive:latest
	@docker push maclotsen/texlive:with-gf
	@docker push maclotsen/texlive:2022
