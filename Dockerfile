ARG ALPINE_TAG
FROM alpine:${ALPINE_TAG}

ARG FRR_TAG
ARG PIP_ARGS=

#git and OpenSSH
RUN apk --no-cache add git openssh

#Shared C build chain
RUN apk --no-cache add autoconf make automake gcc libc-dev

RUN git clone  --progress --verbose --single-branch --branch v2.0.0 https://github.com/CESNET/libyang.git

RUN apk --no-cache add pcre2-dev cmake bsd-compat-headers&& \
    cd libyang && \
    mkdir build; cd build &&\
    cmake -D CMAKE_INSTALL_PREFIX:PATH=/usr -D CMAKE_BUILD_TYPE:String="Release" .. && \
    make --jobs=8 && \
    make install && \
    cd /

RUN git clone --progress --verbose --single-branch --branch frr-${FRR_TAG} https://github.com/frrouting/frr.git frr

RUN cd frr && \
    export PKG_CONFIG_PATH=/usr/lib64/pkgconfig && \
    source alpine/APKBUILD.in apk && apk add --no-cache --update-cache $makedepends && \
    pip install pytest ${PIP_ARGS} && \
    ./bootstrap.sh && \
    ./configure \
--enable-static --enable-static-bin --enable-shared \
--enable-numeric-version \
--disable-dependency-tracking \
--disable-capabilities \
--disable-doc   --disable-bgpd   --disable-ripd   --disable-ripngd  --disable-ospf6d  --disable-ldpd  --disable-nhrpd  --disable-babeld  --disable-isisd  --disable-pimd  --disable-pbrd  --disable-fabricd  --disable-pathd  --disable-bgp-announce  --disable-bgp-vnc  --disable-bgp-bmp  --disable-rtadv  --disable-irdp \
--bindir=/bin \
--sbindir=/lib/frr \
--sysconfdir=/etc/frr \
--libdir=/lib/frr \
--libexecdir=/lib/frr \
--localstatedir=/var/run/frr \
--libdir=/lib/frr \
--with-moduledir=/lib/frr/modules \
--disable-dependency-tracking \
--enable-systemd=no \
--enable-vty-group=frrvty \
SPHINXBUILD=/usr/bin/sphinx-build

RUN cd frr && \
    make --jobs=8 &&\
    make DESTDIR=/compiled install

RUN cp /frr/alpine/frr.pre-install /compiled/usr

CMD echo