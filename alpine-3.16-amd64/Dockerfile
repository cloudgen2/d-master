FROM alpine:3.16
LABEL maintainer="Cloudgen Wong <info@leolio.page>" \
   architecture="amd64/x86_64"

ADD target/usr.tar.gz /
RUN /bin/sh -c "chown root:root -R /usr"

WORKDIR /data
VOLUME ["/data"]
ENTRYPOINT ["/usr/bin/life-line"]
