PROFILE = texlive.profile

texlive: Dockerfile.texlive misc/texlive.profile
	@docker build --build-arg profile=$(PROFILE) -t maclotsen/texlive:latest .
	notify-send 'Makefile' 'Docker finished building TeX Live Latest' || true

with_gf: texlive Dockerfile.google-fonts
	@docker build -f Dockerfile.google-fonts -t maclotsen/texlive:with-gf .
	notify-send 'Makefile' 'Docker finished building Google Fonts' || true

publish: texlive with_gf
	@docker push maclotsen/texlive:latest
	@docker push maclotsen/texlive:with-gf
