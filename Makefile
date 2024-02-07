ALPINE_TAG=3.13
FRR_TAG=8.0

TAG = jgodoy/frr\:$(FRR_TAG)-alpine-$(ALPINE_TAG)


.PHONY: build

build:
	docker build . -t $(TAG) \
		--build-arg ALPINE_TAG=$(ALPINE_TAG) \
		--build-arg FRR_TAG=$(FRR_TAG)

install: build
