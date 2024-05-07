FROM alpine:3.16
LABEL maintainer="Cloudgen Wong <info@leolio.page>" \
   architecture="amd64/x86_64"

ADD target/usr.tar.gz /

WORKDIR /data
VOLUME ["/data"]
ENTRYPOINT ["/bin/sh -c /usr/bin/sleep.sh"]
