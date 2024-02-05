FROM ?= ubuntu:22.04
PROFILE ?= texlive.profile
IMAGE ?= maclotsen/texlive:ubuntu

build: Dockerfile profiles/$(PROFILE)
	@docker build --build-arg FROM=$(FROM) --build-arg profile=$(PROFILE) -t $(IMAGE) .
