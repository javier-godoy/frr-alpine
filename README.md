# frr-alpine

Docker image of FRR based on Alpine.

This image is intended as an example on how to compile FRR with a custom configuration (particularly `--disable-capabilities` in order to circumvent https://github.com/FRRouting/frr/issues/8681, and without some modules I didn't use)

Alpine and keepalived versions are configured in Makefile:
```
ALPINE_TAG=3.19.1
FRR_TAG=9.1
```

Alpine 3.19 requires `PIP_ARGS=--break-system-packages`

The compiled binaries are available under `/compiled` and can be included in a multistage build by adding: 
```
FROM jgodoy/frr:latest AS frr

COPY --from=frr /compiled /
RUN apk add --no-cache pcre libyang protobuf-c json-c c-ares iproute2 bash && \
    sh /usr/frr.pre-install && \
    usermod -u 1000 frr
```