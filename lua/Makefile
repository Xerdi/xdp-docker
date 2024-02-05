FROM ?= ubuntu:22.04
IMAGE ?= maclotsen/lua:ubuntu

build: Dockerfile $(PROFILE)
	@docker build --build-arg FROM=$(FROM) -t $(IMAGE) .
