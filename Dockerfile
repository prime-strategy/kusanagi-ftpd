FROM --platform=$BUILDPLATFORM alpine:3.24.3
LABEL maintainer="kusanagi@prime-strategy.co.jp"

RUN : \
    && apk upgrade  --no-cache \
        busybox \
        musl \
        musl-utils \
        zlib \
        libssl3 \
        libcrypto3 \
    && apk add --no-cache \
        vsftpd \
    && addgroup -g 1000 kusanagi \
    && adduser -h /home/kusanagi -s /bin/false -u 1000 -G kusanagi -D kusanagi
COPY files/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY files/user_list /etc/vsftpd/user_list
COPY files/docker-entrypoint.sh /
EXPOSE 21 50021-50040

CMD ["/docker-entrypoint.sh"]
