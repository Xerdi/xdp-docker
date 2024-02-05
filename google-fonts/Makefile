FROM ?= ubuntu:22.04
IMAGE ?= maclotsen/google-fonts:ubuntu

build: Dockerfile $(PROFILE)
	@docker build --build-arg FROM=$(FROM) -t $(IMAGE) .
