# frr-alpine

Docker image of FRR based on Alpine 3.13.

This image is intended as an example on how to compile FRR with a custom configuration (particularly `--disable-capabilities` in order to circumvent https://github.com/FRRouting/frr/issues/8681, and without some modules I didn't use)


The compiled binaries are available under `/compiled` and can be included in a multistage build by adding: 
```
FROM jgodoy/frr:latest AS frr

COPY --from=frr /compiled /
RUN apk add --no-cache json-c c-ares iproute2 python3 bash libyang && \
    sh /usr/frr.pre-install
```