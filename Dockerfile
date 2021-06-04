FROM alpine:3.13.5

RUN apk add --update --no-cache frr tini 

COPY init /usr/local/bin/init 
RUN chmod +x /usr/local/bin/init

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["init"]
