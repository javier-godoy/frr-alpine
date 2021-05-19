TAG = jgodoy/frr\:latest

.PHONY: build

build:
	docker build . -t $(TAG)

install: build