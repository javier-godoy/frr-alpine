ALPINE_TAG=3.19.1
PIP_ARGS=--break-system-packages

TAG = jgodoy/frr\:$(FRR_TAG)-alpine-$(ALPINE_TAG)


.PHONY: build

build:
	docker build . -t $(TAG) \
		--build-arg ALPINE_TAG=$(ALPINE_TAG) \
		--build-arg FRR_TAG=$(FRR_TAG) \
		--build-arg PIP_ARGS=$(PIP_ARGS)

install: build
