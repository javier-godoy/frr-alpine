TAG = jgodoy/frr\:8.0

.PHONY: build

build:
	docker build . -t $(TAG)

install: build
