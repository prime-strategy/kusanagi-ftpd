FROM --platform=$BUILDPLATFORM alpine:3.22.0
LABEL maintainer="kusanagi@prime-strategy.co.jp"

RUN : \
    && apk add --no-cache \
        vsftpd \
        libssl3=3.5.1-r0 \
        libcrypto3=3.5.1-r0 \
    && addgroup -g 1000 kusanagi \
    && adduser -h /home/kusanagi -s /bin/false -u 1000 -G kusanagi -D kusanagi
COPY files/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY files/user_list /etc/vsftpd/user_list
COPY files/docker-entrypoint.sh /
EXPOSE 21 50021-50040

RUN apk add --no-cache --virtual .curl curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /tmp \
    && /tmp/trivy filesystem --skip-files /tmp/trivy --exit-code 1 --no-progress / \
    && apk del .curl \
    && rm /tmp/trivy \
    && :

CMD ["/docker-entrypoint.sh"]
