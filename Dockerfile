FROM alpine:3.13

RUN apk --no-cache add git openssh 

RUN git clone https://github.com/frrouting/frr.git frr

RUN cd frr && \
    git checkout origin/stable/7.5 -b local && \
    source alpine/APKBUILD.in apk && apk add --no-cache --update-cache $makedepends && \
    pip install pytest && \
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