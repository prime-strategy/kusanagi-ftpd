FROM alpine:3.12.3
MAINTAINER kusanagi@prime-strategy.co.jp

RUN apk add --no-cache vsftpd \
&& addgroup -g 1000 kusanagi \
&& adduser -h /home/kusanagi -s /bin/false -u 1000 -G kusanagi -D kusanagi
COPY files/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY files/user_list /etc/vsftpd/user_list
COPY files/docker-entrypoint.sh /
EXPOSE 21 50021-50040

CMD /docker-entrypoint.sh
